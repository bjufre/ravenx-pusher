# RavenxPusher
[![Hex pm](http://img.shields.io/hexpm/v/ravenx_pusher.svg?style=flat)](https://hex.pm/packages/ravenx_pusher)
[![Travis CI](https://img.shields.io/travis/behind-design/ravenx-pusher.svg)](https://travis-ci.org/behind-design/ravenx-pusher)

RavenxPusher is a custom strategy for [`ravenx`](https://github.com/acutario/ravenx) so we can send notifications
through pusher in an easy and nice way.

## Installation

To install this package, you need to add  `ravenx_pusher` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ravenx_pusher, "~> 0.2.0"}]
end
```
And second you need to add it to the list of `Ravenx` strategies in the config in order for it to work:
```elixir
config :ravenx, :strategies, [
  pusher: Ravenx.Strategy.Pusher
]
```

# Configuration

___** In order to use `Pusher` you'll need the following items from your [apps dashboard](https://dashboard.pusher.com/apps) so we can configure it properly:___
- `app_id`: In Pusher `app_id`.
- `app_key`: In Pusher `key`.
- `secret`: In Pusher `secret`.

Once we have them we can proceed.

As explained in the [`ravenx`](https://github.com/actuario/ravenx) __configuration__ section, we have different ways of configuring the adapters:

1. Passing the options in the dispatch call:
```elixir
iex> Ravenx.dispatch(:pusher, %{event: "my-event", data: "Data to send", channels: "my-channel"}, %{host: "localhost", port: 8080, app_id: "myAppId", app_key: "myAppKey", secret: "myAppSecret"})
```
2. Specifying a configuration module in your application config:
```elixir
config :ravenx,
  config: YourApp.RavenxConfig
```
And creating that module:
```elixir
defmodule YourApp.RavenxConfig do
  def pusher(_payload) do
    %{
      app_id: "...",
      app_key: "...",
      secret: "...",
      host: "...",
      port: ... # 8080 for example
    }
  end
end
```
__Note__: the module should contain a function called as the strategy yopu are configuring, receiving the payload and returning a configuration Keyword list.

3. Specifying the configuration directly on your application config file:
```elixir
config :ravenx, :pusher,
  app_id: "...",
  app_key: "...",
  secret: "...",
  host: "...",
  port: ... # 8080 for example
```

If you want to know more about configuration options or `ravenx` itself go to their [README](https://github.com/acutario/ravenx).

# Dispatching

To dispatch any notification through `Pusher` you need to pass a map (as the second parameter) to `Ravenx.dispatch(:pusher, to_dispatch, opts \\ %{})` with the following keys:
- data: The data to send.
- event: The name of the event.
- channels: The channels where the notification will go through (this can be either a `String` or a `List(String.t)`).


# License

Check [LICENSE](https://github.com/behind-design/ravenx-pusher/blob/master/LICENSE).