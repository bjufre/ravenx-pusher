{application,ravenx,
             [{applications,[kernel,stdlib,elixir,logger,bamboo,bamboo_smtp,
                             hackney]},
              {description,"Notification dispatch library for Elixir applications.\n"},
              {modules,['Elixir.Ravenx','Elixir.Ravenx.Notification',
                        'Elixir.Ravenx.NotificationBehaviour',
                        'Elixir.Ravenx.Strategy.Dummy',
                        'Elixir.Ravenx.Strategy.Email',
                        'Elixir.Ravenx.Strategy.Slack',
                        'Elixir.Ravenx.StrategyBehaviour']},
              {registered,[]},
              {vsn,"1.0.0"},
              {included_applications,[httpotion,poison,bamboo]}]}.