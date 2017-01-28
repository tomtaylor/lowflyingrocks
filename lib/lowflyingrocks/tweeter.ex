defmodule LowFlyingRocks.Tweeter do
  require Logger
  use GenServer
  use Timex
  alias Timex.Duration

  def start_link(name \\ nil) do
    GenServer.start_link(__MODULE__, :ok, [name: name])
  end

  def set_tweets(server, tweets) do
    GenServer.call(server, {:set_tweets, tweets})
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_call({:set_tweets, new_tweets}, _from, _state) do
    tweets = new_tweets |> filter_old_tweets |> sort_tweets_by_timestamp
    first_tweet = Enum.at(tweets, 0)
    timeout = timeout_for_tweet(first_tweet)
    {:reply, :ok, tweets, timeout}
  end

  def handle_info(:timeout, tweets) do
    {tweet, new_tweets} = List.pop_at(tweets, 0)
    publish_tweet(tweet)

    next_tweet = Enum.at(new_tweets, 0)
    timeout = timeout_for_tweet(next_tweet)
    {:noreply, new_tweets, timeout}
  end

  defp timeout_for_tweet(nil) do
    :infinity
  end

  defp timeout_for_tweet({timestamp, _body}) do
    timestamp
    |> Timex.diff(Timex.now, :duration)
    |> Duration.to_milliseconds(truncate: true)
    |> max(0)
  end

  defp publish_tweet(nil) do
    # no-op
  end

  defp publish_tweet({_timestamp, body}) do
    Logger.info(body)

    if Application.fetch_env!(:lowflyingrocks, :perform_tweets) do
      ExTwitter.update(body)
    end
  end

  defp filter_old_tweets(tweets) do
    now = DateTime.utc_now()

    tweets |> Enum.filter(fn({t, _}) ->
      compare_timestamps(t, now)
    end)
  end

  defp sort_tweets_by_timestamp(tweets) do
    tweets |> Enum.sort_by(fn({a, _}, {b, _}) ->
      compare_timestamps(a, b)
    end)
  end

  defp compare_timestamps(a, b) do
    case DateTime.compare(a, b) do
      :eq -> true
      :gt -> true
      :lt -> false
    end
  end

end
