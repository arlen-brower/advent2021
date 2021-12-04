defmodule BingoBoard do
  @moduledoc """
  Abstraction of a Bingo Board for Advent of Code Day 4
  Assumes a row/col size of 5x5
  Expects an input of a list of binaries, e.g.:
    ["85 23 65 78 93",
     "27 53 10 12 26",
     "5 34 83 25  6",
     "56 40 73 29 54",
     "33 68 41 32 82"]
  """
  defstruct numbers: :nil,
            sets: :nil

  def new(list) do
    split_nums =
      Enum.map(list, &String.split/1)

    nums = List.flatten(split_nums)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()

    rows = create_rows(split_nums, [])
    |> Enum.map(&MapSet.new(&1))
    cols = create_columns([], nums, 4)
    |> Enum.map(&MapSet.new(&1))

    %BingoBoard{numbers: nums, sets: List.flatten([rows | cols])}
  end

  def calc_win(board, drawn, last) do
    allnums = Enum.reduce(
      board.sets,
      MapSet.new(),
      fn set, uni -> MapSet.union(set, uni) end)
    unmarked = MapSet.difference(allnums, drawn)
    (Enum.sum(unmarked) )* last
  end

  def check_win(board, drawn) do
    do_check(board.sets, drawn, :false)
  end

  defp do_check(_, _, win) when win, do: :true # Winning numbers
  defp do_check([], _, _), do: :false        # No winning numbers
  defp do_check([head|sets], drawn, _) do
    do_check(sets, drawn, MapSet.subset?(head, drawn))
  end

  def create_columns(list, _, col) when col < 0, do: list
  def create_columns(list, nums, col) do
    col_list = for r <- 0..4,do: elem(nums, col+5* r)
    create_columns( [col_list | list], nums, col-1)
  end

  defp create_rows([], row_list), do: row_list
  defp create_rows([head | tail], row_list) do
    temp_list = Enum.map(head, &String.to_integer/1)
    create_rows( tail, [ temp_list | row_list])
  end

  def get(_, row, col) when row > 4 or col > 4, do: :nil
  def get(board, row, col) do
    pos = row + 5 * col
    elem(board.numbers, pos)
  end

end


defmodule Bingo do
@moduledoc """
Bingo board portion of the task.
"""
  def crush_squid(path) do
    [draw | board_dat] = File.stream!(path)
    |> Enum.map(&String.trim_trailing/1)

    boards = Stream.reject(board_dat, fn c -> c == "" end)
    |> Enum.chunk_every(5)
    |> lists_to_structs([])

    draw = String.split(draw, ",")
    |> Enum.map(&String.to_integer/1)

    play_game(draw, MapSet.new(), boards, 0, :false)
  end

  def play_game(_, drawn, boards, last, :true) do
    Enum.filter(boards,
                fn board -> BingoBoard.check_win(board, drawn) end)
    |> hd()
    |> BingoBoard.calc_win(drawn, last)
  end

  def play_game([draw | pool], drawn, boards, _, :false) do
    drawn = MapSet.put(drawn, draw)
    win = Enum.reduce(
      boards,
      :false,
      fn board, truth -> truth or BingoBoard.check_win( board, drawn) end
    )
    play_game(pool, drawn, boards, draw, win)
  end

  def lists_to_structs([], struct_list), do: struct_list
  def lists_to_structs([head | tail], struct_list) do
    lists_to_structs(tail, [BingoBoard.new(head) | struct_list])
  end

end
