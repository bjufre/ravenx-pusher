defmodule RavenxPusher.Mixfile do
  use Mix.Project

  @version "0.1.2"

  def project do
    [app: :ravenx_pusher,
     version: @version,
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_paths: elixirc_paths(Mix.env),
     deps: deps(),
     description: description(),
     package: package(),
     docs: docs()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  def elixirc_paths(:test), do: ["lib", "test/support"]
  def elixirc_paths(_), do:     ["lib"]

  defp docs do
    [
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/ravenx_pusher",
      main: "RavenxPusher",
      source_url: "https://github.com/behind-design/ravenx-pusher",
      extras: ["README.md"]
    ]
  end

  defp description do
    """
    Strategy to send notifications through Pusher with Ravenx.
    """
  end

  defp package do
    [
     name: :ravenx_pusher,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Bernat Jufré Martínez"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/behind-design/ravenx-pusher"}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
     # Must
     {:ravenx, "~> 1.0.0"},
     {:pusher, "~> 0.1.3"},
     {:plug, "~> 1.0"},

     # Docs
     {:ex_doc, "~> 0.16", only: :dev, runtime: false},
     {:earmark, ">= 1.2.3", only: :dev, runtime: false},

     # Testing
     {:bypass, "~> 0.8", only: [:dev, :test]},
     {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
    ]
  end
end
