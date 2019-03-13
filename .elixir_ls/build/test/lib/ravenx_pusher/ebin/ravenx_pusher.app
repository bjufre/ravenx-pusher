{application,ravenx_pusher,
             [{applications,[kernel,stdlib,elixir,logger,pusher,plug,
                             plug_cowboy,bypass,ravenx]},
              {description,"Strategy to send notifications through Pusher with Ravenx.\n"},
              {modules,['Elixir.Ravenx.Strategy.Pusher','Elixir.RavenxPusher',
                        'Elixir.RavenxPusher.Push',
                        'Elixir.RavenxPusher.TestConfig']},
              {registered,[]},
              {vsn,"0.2.1"}]}.
