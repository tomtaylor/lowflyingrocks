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

  def handle_call({:set_tweets, tweets}, _from, _state) do
    cleaned_tweets = clean_tweets(tweets)
    first_tweet = Enum.at(cleaned_tweets, 0)
    timeout = timeout_for_tweet(first_tweet)
    {:reply, :ok, cleaned_tweets, timeout}
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
    Timex.diff(timestamp, Timex.now, :duration)
    |> Duration.to_milliseconds(truncate: true)
    |> abs()
  end

  defp publish_tweet(nil) do
    # no-op
  end

  defp publish_tweet({_timestamp, body}) do
    Logger.info("Publishing tweet: #{body}")

    if Application.get_env(:lowflyingrocks, :perform_tweets) do
      ExTwitter.update(body)
    end
  end

  defp clean_tweets(tweets) do
    now = DateTime.utc_now()

    tweets |> Enum.filter(fn({t, _}) ->
      case DateTime.compare(t, now) do
        :eq -> true
        :gt -> true
        :lt -> false
      end
    end)
  end

end
