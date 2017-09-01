defmodule RavenxPusher do
  @moduledoc """
  RavenxPusher is a Strategy to send notifications through Pusher with Ravenx.
  """

  alias RavenxPusher.Push

  @behaviour Ravenx.StrategyBehaviour

  @push_required [:data, :event, :channels]
  @required_options [:host, :port, :app_id, :app_key, :secret]

  @doc """
  `call/2` Accepts a payload and an options map
  an returns `{:ok, %Push{}}` if the notification
  could be sent, `{:error, {:missing_config, error}}` in case
  any required config fields are missing, or `{:error, {:pusher_error, %Push{}}}`
  in case there was an error when sending the notification.
  """
  @spec call(Ravenx.notif_payload, Ravenx.notif_options)
  :: {:ok, Push.t}
  | {:error, {:missing_config, any}}
  | {:error, {:pusher_error, Push.t}}
  def call(payload, opts \\ %{}) when is_map(payload) and is_map(opts) do
    options = parse_options(opts)

    %Push{}
    |> parse_payload(payload)
    |> send_push(options)
  end

  @spec send_push(payload :: map, options :: map)
  :: {:ok, Push.t}
  | {:error, {:missing_config, any}}
  | {:error, {:pusher_error, Push.t}}
  defp send_push(payload, opts)

  for field <- @required_options do
    defp send_push(_push, %{unquote(field) => f}) when is_nil(f) or f === "" do
      {:error, {:missing_config, unquote(field)}}
    end
  end

  for field <- @push_required do
    defp send_push(%Push{unquote(field) => f}, _opts) when is_nil(f) or f === "" do
      {:error, {:missing_field, unquote(field)}}
    end
  end

  defp send_push(%Push{} = push, %{host: host, port: port, app_id: aid, app_key: akey, secret: secret}) do
    Pusher.configure!(host, port, aid, akey, secret)
    case Pusher.trigger(push.event, push.data, push.channels, push.socket_id) do
      :ok    -> {:ok, %{ push | sent?: true }}
      :error -> {:error, {:pusher_error, push}}
    end
  end

  defp parse_payload(push, payload) do
    push
    |> add_to_push(:data, Map.get(payload, :data))
    |> add_to_push(:event, Map.get(payload, :event))
    |> add_to_push(:channels, Map.get(payload, :channels))
    |> add_to_push(:socket_id, Map.get(payload, :socket_id))
  end

  defp parse_options(opts) do
    %{}
    |> add_to_options(:host, Map.get(opts, :host))
    |> add_to_options(:port, Map.get(opts, :port))
    |> add_to_options(:app_id, Map.get(opts, :app_id))
    |> add_to_options(:app_key, Map.get(opts, :app_key))
    |> add_to_options(:secret, Map.get(opts, :secret))
  end

  defp add_to_push(push, key, value), do: Map.put(push, key, value)

  defp add_to_options(opts, key, value), do: Map.put(opts, key, value)
end
