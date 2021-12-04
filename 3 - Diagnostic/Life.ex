defmodule Life do

  def get_life!(path) do
    lines = File.stream!(path)
    |> Enum.map(&String.trim_trailing/1)
    o = oxy(lines) |> String.to_integer(2)
    c = c02(lines) |> String.to_integer(2)
    o * c
  end

  def oxy(list), do: filter_oxy(list, "", 0)
  def c02(list), do: filter_c02(list, "", 0)

  def filter_c02(list, _, _) when length(list) == 1, do: hd list
  def filter_c02(list, pattern, col) do
    pattern = pattern <>
    (get_columns(list, col)
    |> zero_or_one
    |> invert)
    list = Enum.filter(list, &String.starts_with?(&1, pattern))
    filter_c02(list, pattern, col + 1)
  end

  def filter_oxy(list, _, _) when length(list) == 1, do: hd list
  def filter_oxy(list, pattern, col) do
    pattern = pattern <>
    (get_columns(list, col)
    |> zero_or_one)
    list = Enum.filter(list, &String.starts_with?(&1, pattern))
    filter_oxy(list, pattern, col + 1)
  end

  def get_columns(list, col) do
    Enum.reduce(
      list,
      [],
      fn e, acc -> [String.at(e,col) | acc] end)
  end

  def invert(num) when num == "0", do: "1"
  def invert(num) when num == "1", do: "0"

  def zero_or_one(list), do: zero_or_one(list, 0,0)
  def zero_or_one([], zeros, ones) when zeros > ones, do: "0"
  def zero_or_one([], _, _), do: "1"
  def zero_or_one([head | tail], zeros, ones) when head == "0" do
    zero_or_one(tail, zeros+1, ones)
  end
  def zero_or_one([head | tail], zeros, ones) when head == "1" do
    zero_or_one(tail, zeros, ones+1)
  end

end
