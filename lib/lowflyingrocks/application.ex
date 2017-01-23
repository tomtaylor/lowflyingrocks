defmodule LowFlyingRocks.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
       worker(LowFlyingRocks.Tweeter, [LowFlyingRocks.Tweeter]),
       worker(LowFlyingRocks.Importer, [LowFlyingRocks.Importer]),
    ]

    opts = [strategy: :rest_for_one, name: LowFlyingRocks.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
