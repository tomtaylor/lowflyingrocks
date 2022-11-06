defmodule LowFlyingRocks.Mastodon do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    conn =
      Application.get_env(:lowflyingrocks, :mastodon, [])
      |> Hunter.new()

    {:ok, conn}
  end

  def publish(text) do
    GenServer.call(__MODULE__, {:publish, text}, 30_000)
  end

  def handle_call({:publish, text}, _from, conn) do
    %Hunter.Status{} = status = Hunter.create_status(conn, text)

    {:reply, status, conn}
  end
end
