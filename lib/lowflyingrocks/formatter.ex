defmodule LowFlyingRocks.Formatter do
  def format(neo) do
    t = neo.timestamp
    body = generate_body(neo)
    {t, body}
  end

  defp generate_body(neo) do
    "#{neo.name}, #{format_diameter_range(neo)} in diameter, just passed the Earth at #{
      format_speed(neo)
    }, missing by #{format_distance(neo)}. #{neo.url}"
  end

  defp format_diameter_range(neo) do
    min = neo.diameter_min |> round
    max = neo.diameter_max |> round
    "#{min}m-#{max}m"
  end

  defp format_speed(neo) do
    s = neo.speed |> round
    "#{s}km/s"
  end

  defp format_distance(neo) do
    au = neo.distance
    km = au * 149_598_000
    count = km |> round |> Integer.digits() |> Enum.count()
    non_sig_count = count - 3
    divider = :math.pow(10, non_sig_count)
    s = round(km / divider) * divider
    "#{Number.Delimit.number_to_delimited(s, precision: 0)}km"
  end
end
