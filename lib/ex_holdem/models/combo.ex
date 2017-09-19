defmodule ExHoldem.Combo do

  alias ExHoldem.Card
  alias ExHoldem.Combo

  defstruct name: nil,
            power: nil, # tuple of integers
            hand_index: nil, # 0, 1, 2
            cards: [] # five cards

  def calculate(cards = [_|_]) when length(cards) == 7 do
    cards
    |> permutations(5)
    |> Enum.map(fn(cards) ->
      Enum.sort_by(cards, fn(%Card{rank: rank}) ->
        rank
      end)
      |> eval
    end)

  end

  def permutations([], _), do: []
  def permutations(lst = [_|_], permsize)
        when (is_integer(permsize) and (length(lst) >= permsize)) do
    lst
    |> Enum.with_index
    |> permutations_inner(permsize, [])
    |> List.flatten
    |> Enum.map(&Tuple.to_list/1)
  end

  defp permutations_inner(_, permsize, acc) when (length(acc) == permsize) do
    List.to_tuple(acc)
  end
  defp permutations_inner(lst, permsize, acc)
        when (length(acc) < permsize) do
    Enum.map(lst, fn({item, item_index}) ->
      new_lst = Enum.filter(lst, fn({_, index}) -> index != item_index end)
      permutations_inner(new_lst, permsize, [item|acc])
    end)
  end

  @spec eval([%Card{}]) :: %Combo{}
  defp eval(_) do
    #
    # TODO
    #
  end

end
