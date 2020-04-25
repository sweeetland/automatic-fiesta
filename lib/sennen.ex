defmodule Sennen do
  @max_concurrency 3
  @number_of_locations 9
  @ss_base_url "https://api.sunrise-sunset.org/json?formatted=0"

  def start do
    generate_n_locations(@number_of_locations)
    |> fetch_stats()
    |> filter_invalid_stats()
    |> IO.inspect()
  end

  defp generate_n_locations(n) do
    Enum.map(1..n, &generate_random_location/1)
  end

  defp generate_random_location(_) do
    {Enum.random(-180..180), Enum.random(-180..180)}
  end

  defp fetch_stats(locations) do
    locations
    |> Task.async_stream(&get_stats_for_location/1, max_concurrency: @max_concurrency)
    |> Enum.into([], fn {:ok, res} -> res end)
  end

  defp get_stats_for_location({lat, lng}) do
    case HTTPoison.get("#{@ss_base_url}&lat=#{lat}&lng=#{lng}") do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, parsed_body} = Jason.decode(body)
        parsed_body["results"]

      {_, _} ->
        IO.puts("could not fetch stats for location [#{lat}, #{lng}]")
        {:error}
    end
  end

  defp filter_invalid_stats(stats) do
    Enum.filter(stats, &is_valid_stat/1)
  end

  defp is_valid_stat(%{"day_length" => day_length}), do: day_length > 0
  defp is_valid_stat(_), do: false
end
