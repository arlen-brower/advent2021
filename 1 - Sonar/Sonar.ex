defmodule Sonar do

 @spec count_increase!(binary, integer)
 def count_increase!(path, k \\ 1 ) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(k,1)
    |> Enum.map(&Enum.sum/1)
    |> do_count(:start, 0)
  end

  defp do_count([], _, counter), do: counter

  defp do_count([head | tail], last, counter) when head > last, do:
    do_count(tail, head, counter+1)

  defp do_count([head | tail], _, counter), do:
    do_count(tail, head, counter)

end
