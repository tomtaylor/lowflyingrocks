defmodule LowFlyingRocks.NEO do
  @enforce_keys [:name, :timestamp, :diameter_min, :diameter_max, :speed, :distance, :url]
  defstruct [:name, :timestamp, :diameter_min, :diameter_max, :speed, :distance, :url]
end
