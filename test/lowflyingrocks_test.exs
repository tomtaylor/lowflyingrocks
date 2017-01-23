defmodule LowFlyingRocksTest do
  use ExUnit.Case
  doctest LowFlyingRocks
  alias LowFlyingRocks.{NEO,Formatter,Parser}

  test "parsing json" do
    json = File.read!("test/api.json")
    neos = Parser.parse(json)
    assert Enum.count(neos) == 89
    
    first = neos |> Enum.at(0)

    assert first.name == "2017 AN4"
    assert first.distance == 0.0631318206847728
    assert first.speed == 25.7077504402114
    assert first.diameter_max == 133.48730920412905
    assert first.diameter_min == 59.69733950279317
    assert first.url == "http://ssd.jpl.nasa.gov/sbdb.cgi?sstr=2017%20AN4"
    
    timestamp = DateTime.from_naive!(~N[2017-01-16 10:44:00.000], "Etc/UTC")
    assert (DateTime.compare(timestamp, first.timestamp) == :eq)
  end

  test "formatting NEO" do
    timestamp = DateTime.from_naive!(~N[2017-01-16 10:44:00.000], "Etc/UTC")

    neo = %NEO{
      name: "2017 AN4", 
      timestamp: timestamp,
      distance: 0.0631318206847728, 
      speed: 25.7077504402114,
      diameter_max: 133.48730920412905,
      diameter_min: 59.69733950279317,
      url: "http://ssd.jpl.nasa.gov/sbdb.cgi?sstr=2017%20AN4"
    }

    {t, s} = Formatter.format(neo)
    assert DateTime.compare(t, timestamp) == :eq
    assert s == "2017 AN4, 60m-133m in diameter, just passed the Earth at 26km/s, missing by 9,440,000km. #{neo.url}"
  end

end
