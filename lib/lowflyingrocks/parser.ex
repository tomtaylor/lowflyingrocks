defmodule LowFlyingRocks.Parser do
  alias LowFlyingRocks.NEO

  def parse(json) do
    Jason.decode!(json)
    |> Map.fetch!("data")
    |> Enum.reject(fn d ->
      d |> Enum.at(10) == nil
    end)
    |> Enum.map(fn d ->
      name = d |> Enum.at(0)
      distance = d |> Enum.at(4) |> parse_float()
      speed = d |> Enum.at(7) |> parse_float()
      h = d |> Enum.at(10) |> parse_float()
      timestamp = d |> Enum.at(3) |> parse_timestamp

      url = "https://ssd.jpl.nasa.gov/sbdb.cgi?sstr=#{name}" |> URI.encode()

      %NEO{
        name: name,
        timestamp: timestamp,
        distance: distance,
        speed: speed,
        diameter_min: diameter_min(h),
        diameter_max: diameter_max(h),
        url: url
      }
    end)
  end

  defp diameter_min(h) do
    h_to_diameter(h, 0.25)
  end

  defp diameter_max(h) do
    h_to_diameter(h, 0.05)
  end

  defp h_to_diameter(h, p) do
    ee = -0.2 * h
    1329.0 / :math.sqrt(p) * :math.pow(10, ee) * 1000
  end

  defp parse_timestamp(ts) do
    s = "{YYYY}-{Mshort}-{0D} {0h24}:{m}"

    Timex.Parse.DateTime.Parser.parse!(ts, s)
    |> DateTime.from_naive!("Etc/UTC")
  end

  defp parse_float(str) do
    {float, _} = Float.parse(str)
    float
  end
end
