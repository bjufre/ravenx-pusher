defmodule RavenxPusher.TestConfig do
  @moduledoc false

  def pusher(_payload) do
    %{
      host: "http://localhost",
      port: Application.get_env(:ravenx_pusher, :bypass_port),
      app_id: "SuperAwesomeTestAppId",
      app_key: "SuperAwesomeTestAppKey",
      secret: "superSecretTest"
    }
  end
end