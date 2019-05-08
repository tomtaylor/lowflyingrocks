defmodule LowFlyingRocks.Importer do
  require Logger
  use GenServer
  alias LowFlyingRocks.{Parser, Formatter, Tweeter}

  def start_link(name \\ nil) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def init(:ok) do
    {:ok, {}, 0}
  end

  def handle_info(:timeout, _) do
    run()
    timeout = trunc(interval() * 1000)
    {:noreply, {}, timeout}
  end

  defp run do
    case fetch() do
      {:ok, body} ->
        body |> parse |> format |> schedule

      :error ->
        Logger.error("Failed to download NEOs")
    end
  end

  defp fetch do
    Logger.info("Downloading NEOs from JPL API")
    response = HTTPotion.get("https://ssd-api.jpl.nasa.gov/cad.api?dist-max=0.2", timeout: 30_000)

    case HTTPotion.Response.success?(response) do
      true -> {:ok, response.body}
      false -> :error
    end
  end

  defp parse(json) do
    Parser.parse(json)
  end

  defp format(neos) do
    neos |> Enum.map(&Formatter.format/1)
  end

  defp schedule(tweets) do
    Tweeter.set_tweets(LowFlyingRocks.Tweeter, tweets)
  end

  defp interval do
    Application.fetch_env!(:lowflyingrocks, :import_interval)
  end
end
