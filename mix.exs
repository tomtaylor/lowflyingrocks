defmodule LowFlyingRocks.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lowflyingrocks,
      version: "0.1.0",
      elixir: "~> 1.7",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger], mod: {LowFlyingRocks.Application, []}]
  end

  defp deps do
    [
      {:timex, "~> 3.5"},
      {:poison, "~> 3.0"},
      {:httpotion, "~> 3.0"},
      {:number, "~> 0.5.0"},
      {:oauth, github: "tim/erlang-oauth"},
      {:extwitter, "~> 0.7"},
      {:distillery, "~> 2.0.0"}
    ]
  end
end
