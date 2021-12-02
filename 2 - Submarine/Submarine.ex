defmodule Submarine do

  def find_location!(path) do
    File.stream!(path)
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.split/1)
    |> Enum.map(&{List.first(&1), List.last(&1)|>String.to_integer})
    |> read_move(0,0,0)
  end

  defp read_move([], depth, pos, _), do: depth * pos
  defp read_move([ {"up", num} | tail], depth, pos, aim), do:
    read_move(tail, depth, pos, aim-num)

  defp read_move([ {"down", num} | tail], depth, pos, aim), do:
    read_move(tail, depth, pos, aim+num)

  defp read_move([ {"forward", num} | tail], depth, pos, aim), do:
    read_move(tail, depth+(aim*num), pos+num, aim)
end
