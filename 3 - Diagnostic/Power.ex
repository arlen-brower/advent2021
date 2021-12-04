defmodule Power do

  def get_power!() do
    File.stream!("test.txt")
    |> Enum.map(&String.trim_trailing/1)
    |> convert([])
    |> Enum.reduce(
      [],
      fn el, acc -> [zero_or_one(el) | acc] end
    )
    |> calc_power
  end

  def calc_power(gamma) do
    epsilon = Enum.map(gamma, &invert/1)
            |> to_string
            |> String.to_integer(2)
    gamma = to_string(gamma)
            |> String.to_integer(2)
    epsilon * gamma
  end

  def invert(num) when num == 48, do: 49
  def invert(num) when num == 49, do: 48

  def zero_or_one(charlist) do
    ones = Enum.count(charlist, fn c -> c == 49 end) # Count the ones
    if ones > 5, do: 49, else: 48
  end

  def convert( [head|_], col_list) when head == "", do: col_list
  def convert(line_list,col_list ) do
    {line_list, col} = get_cols(line_list, [], [])
    convert(line_list, [col | col_list])
  end

  def get_cols([], col_bin, new_list), do: {new_list, col_bin}
  def get_cols([ <<b1, rest::binary>> | tail], col_bin, new_list) do
    get_cols(tail, [b1 | col_bin], [rest| new_list])
  end
end
