defmodule LowFlyingRocks.Mixfile do
  use Mix.Project

  def project do
    [app: :lowflyingrocks,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     applications: [
       :timex, :httpotion, :extwitter, :edeliver, :poison, :oauth, :number,
       :decimal
     ],
     mod: {LowFlyingRocks.Application, []}]
  end

  defp deps do
    [
      {:timex, "~> 3.0"},
      {:poison, "~> 2.0"},
      {:httpotion, "~> 3.0.2"},
      {:number, "~> 0.5.0"},
      {:oauth, github: "tim/erlang-oauth"},
      {:extwitter, "~> 0.7"},
      {:edeliver, "~> 1.4.0"},
      {:distillery, ">= 0.8.0", warn_missing: false},
    ]
  end
end
