defmodule LowFlyingRocks.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lowflyingrocks,
      version: "0.1.0",
      elixir: "~> 1.9",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        lowflyingrocks: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent]
        ]
      ]
    ]
  end

  def application do
    [extra_applications: [:logger], mod: {LowFlyingRocks.Application, []}]
  end

  defp deps do
    [
      {:timex, "~> 3.5"},
      {:mojito, "~> 0.7.5"},
      {:number, "~> 1.0"},
      {:extwitter, "~> 0.12"},
      {:oauther, "~> 1.1"},
      {:jason, "~> 1.2"},
      {:hunter, "~> 0.5"}
    ]
  end
end
