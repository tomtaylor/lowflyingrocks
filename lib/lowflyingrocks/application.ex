defmodule LowFlyingRocks.Application do
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    log_config()

    import Supervisor.Spec, warn: false

    children = [
      LowFlyingRocks.Tweeter,
      LowFlyingRocks.Importer,
      LowFlyingRocks.Mastodon
    ]

    opts = [strategy: :rest_for_one, name: LowFlyingRocks.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp log_config do
    interval = Application.fetch_env!(:lowflyingrocks, :import_interval)
    Logger.info("Set to import every #{interval} seconds")

    perform_tweets = Application.fetch_env!(:lowflyingrocks, :perform_tweets)
    Logger.info("Perform tweets set to #{perform_tweets}")
  end
end
