defmodule LowFlyingRocks.Importer do
  require Logger
  use GenServer
  alias LowFlyingRocks.{Parser, Formatter, Tweeter}

  @url "https://ssd-api.jpl.nasa.gov/cad.api?dist-max=0.2"
  @timeout 30_000

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
        body |> parse |> format |> schedule |> log

      :error ->
        Logger.error("Failed to download NEOs")
    end
  end

  defp fetch do
    Logger.info("Downloading NEOs from JPL API")

    case do_request() do
      {:ok, %Mojito.Response{status_code: 200, body: body}} -> {:ok, body}
      _ -> :error
    end
  end

  defp do_request() do
    headers = []
    body = ""
    opts = [timeout: @timeout, pool: false]

    Mojito.request(:get, @url, headers, body, opts)
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

  defp log({:ok, tweets}) do
    Logger.info("Scheduled #{Enum.count(tweets)} tweets")
  end
end
