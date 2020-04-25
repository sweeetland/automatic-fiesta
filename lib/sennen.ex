defmodule Sennen do
  @number_of_locations 9

  def start do
    generate_n_locations(@number_of_locations)
    |> IO.inspect()
  end

  defp generate_n_locations(n) do
    Enum.map(1..n, &generate_random_location/1)
  end

  defp generate_random_location(_) do
    {Enum.random(-180..180), Enum.random(-180..180)}
  end
end
