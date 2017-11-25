defmodule RavenxPusherTest do
  @moduledoc false

  use ExUnit.Case
  alias Plug.Conn

  alias RavenxPusher.Push
  alias Ravenx.Strategy.Pusher

  @push_required [:data, :event, :channels]
  @required_options [:host, :port, :app_id, :app_key, :secret]

  setup do
    bypass = Bypass.open

    Application.put_env(:ravenx_pusher, :bypass_port, bypass.port)

    payload = %{
      data: "data",
      channels: "my-channel",
      event: "my-super-event"
    }

    opts = %{
      host: "http://localhost",
      port: bypass.port,
      app_id: "SuperAwesomeAppId",
      app_key: "SuperAwesomeAppKey",
      secret: "superSecret",
    }

    Application.put_env(:ravenx, :config, RavenxPusher.TestConfig)

    Application.put_env(:ravenx, :strategies, [
      pusher: Ravenx.Strategy.Pusher
    ])

    {:ok, bypass: bypass, payload: payload, opts: opts}
  end

  for field <- @required_options do
    test "`call/2` returns `{:error, {:missing_config, #{field}}` when #{field} is not present.", %{payload: payload, opts: opts} do
      options = Map.delete(opts, unquote(field))
      response = Pusher.call(payload, options)

      assert {:error, {:missing_config, unquote(field)}} = response
    end
  end

  for field <- @push_required do
    test "`call/2` returns `{:error, {:missing_field, #{field}}` when #{field} is not present.", %{payload: payload, opts: opts} do
      payload = Map.delete(payload, unquote(field))
      response = Pusher.call(payload, opts)

      assert {:error, {:missing_field, unquote(field)}} = response
    end
  end

  test "`Ravenx.available_strategies` returns the default strategies plus `RavenxPusher.Strategy`" do
    strategies = Ravenx.available_strategies
    assert pusher: Ravenx.Strategy.Pusher in strategies
  end

  test "`Ravenx.dispatch/3` returs `{:error, {:pusher_error, %Push{}}}` when something goes wrong with pusher.", %{bypass: bypass, payload: payload} do
    Bypass.expect bypass, fn(conn) -> Conn.resp(conn, 403, "") end

    response = Ravenx.dispatch(:pusher, payload)

    assert {:error, {:pusher_error, %Push{} = push}} = response
  end

  @expected_body JSX.encode!(%{
    data: "data",
    name: "my-super-event",
    channels: ["my-channel"],
  })

  test "`Ravenx.dispatch/3` returs `{:ok, %Push{}}` when everything goes as planned.", %{bypass: bypass, payload: payload} do
    Bypass.expect bypass, fn(conn) ->
      assert {"content-type", "application/json"} in conn.req_headers
      assert "/apps/SuperAwesomeTestAppId/events" === conn.request_path
      {:ok, req_body, _} = Conn.read_body(conn)
      assert @expected_body === req_body
      Conn.resp(conn, 200, "")
    end

    response = Ravenx.dispatch(:pusher, payload)

    assert {:ok, %Push{} = push} = response
    assert push.data === "data"
    assert push.channels === ["my-channel"]
    assert push.event === "my-super-event"
    assert push.sent?
    refute push.socket_id
  end

  test "`Ravenx.dispatch/3` returs `{:ok, %Push{}}` overrides the options when passed.", %{bypass: bypass, payload: payload, opts: options} do
    Bypass.expect bypass, fn(conn) ->
      assert {"content-type", "application/json"} in conn.req_headers
      {:ok, req_body, _} = Conn.read_body(conn)
      assert @expected_body === req_body
      assert "/apps/SuperAwesomeAppId/events" === conn.request_path
      Conn.resp(conn, 200, "")
    end

    response = Ravenx.dispatch(:pusher, payload, options)

    assert {:ok, %Push{} = push} = response
    assert push.data === "data"
    assert push.channels === ["my-channel"]
    assert push.event === "my-super-event"
    assert push.sent?
    refute push.socket_id
  end
end
