defmodule ExHoldem.Combo do

  use ExHoldem.Constants

  alias ExHoldem.Card
  alias ExHoldem.Combo

  defstruct type: nil,
            power: nil, # tuple of integers
            hand_index: nil, # 0, 1, 2
            cards: [] # five cards

  def calculate(cards = [_|_]) when length(cards) == 7 do
    cards
    |> permutations(5)
    |> Enum.map(fn(cards) ->
      Enum.group_by(cards, fn(%Card{rank: rank}) -> rank end)
      |> Enum.sort(fn({rank1, cards1 = [_|_]},
                      {rank2, cards2 = [_|_]}) ->
        length1 = length(cards1)
        length2 = length(cards2)
        cond do
          (length1 == length2) -> rank1 < rank2
          true -> (length1 > length2)
        end
      end)
      |> Enum.map(fn({_, cards = [_|_]}) -> cards end)
      |> List.flatten
      |> eval
    end)
    |> Enum.max_by(fn(%Combo{type: type, power: power}) ->
      {type, power}
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
  defp eval(cards = [
        %Card{suit: suit, rank: 10},
        %Card{suit: suit, rank: @jack},
        %Card{suit: suit, rank: @queen},
        %Card{suit: suit, rank: @king},
        %Card{suit: suit, rank: @ace},
      ]) do
    %Combo{
      type: @royal_flush,
      cards: cards,
    }
  end
  defp eval(cards = [
        %Card{suit: suit, rank: rank1},
        %Card{suit: suit, rank: rank2},
        %Card{suit: suit, rank: rank3},
        %Card{suit: suit, rank: rank4},
        %Card{suit: suit, rank: rank5},
      ]) when
        (rank1 + 1 == rank2) and
        (rank2 + 1 == rank3) and
        (rank3 + 1 == rank4) and
        (rank4 + 1 == rank5)
      do
    %Combo{
      type: @straight_flush,
      power: rank5,
      cards: cards,
    }
  end
  defp eval(cards = [
        %Card{suit: suit, rank: 2},
        %Card{suit: suit, rank: 3},
        %Card{suit: suit, rank: 4},
        %Card{suit: suit, rank: power = 5},
        %Card{suit: suit, rank: @ace},
      ])
      do
    %Combo{
      type: @straight_flush,
      power: power,
      cards: cards,
    }
  end
  defp eval(cards = [
        %Card{rank: rank},
        %Card{rank: rank},
        %Card{rank: rank},
        %Card{rank: rank},
        %Card{rank: kicker},
      ])
      do
    %Combo{
      type: @four,
      power: {rank, kicker},
      cards: cards,
    }
  end
  defp eval(cards = [
        %Card{rank: rank1},
        %Card{rank: rank1},
        %Card{rank: rank1},
        %Card{rank: rank2},
        %Card{rank: rank2},
      ])
      do
    %Combo{
      type: @full_house,
      power: {rank1, rank2},
      cards: cards,
    }
  end
  defp eval(cards = [
        %Card{suit: suit, rank: rank1},
        %Card{suit: suit, rank: rank2},
        %Card{suit: suit, rank: rank3},
        %Card{suit: suit, rank: rank4},
        %Card{suit: suit, rank: rank5},
      ])
      do
    %Combo{
      type: @flush,
      power: {rank5, rank4, rank3, rank2, rank1},
      cards: cards,
    }
  end
  defp eval(cards = [
        %Card{rank: rank1},
        %Card{rank: rank2},
        %Card{rank: rank3},
        %Card{rank: rank4},
        %Card{rank: rank5},
      ]) when
        (rank1 + 1 == rank2) and
        (rank2 + 1 == rank3) and
        (rank3 + 1 == rank4) and
        (rank4 + 1 == rank5)
      do
    %Combo{
      type: @straight,
      power: rank5,
      cards: cards,
    }
  end
  defp eval(cards = [
        %Card{rank: 2},
        %Card{rank: 3},
        %Card{rank: 4},
        %Card{rank: power = 5},
        %Card{rank: @ace},
      ])
      do
    %Combo{
      type: @straight,
      power: power,
      cards: cards,
    }
  end
  defp eval(cards = [
        %Card{rank: rank},
        %Card{rank: rank},
        %Card{rank: rank},
        %Card{rank: kicker2},
        %Card{rank: kicker1},
      ])
      do
    %Combo{
      type: @three,
      power: {rank, kicker1, kicker2},
      cards: cards,
    }
  end
  defp eval(cards = [
        %Card{rank: rank2},
        %Card{rank: rank2},
        %Card{rank: rank1},
        %Card{rank: rank1},
        %Card{rank: kicker},
      ])
      do
    %Combo{
      type: @two_pairs,
      power: {rank1, rank2, kicker},
      cards: cards,
    }
  end
  defp eval(cards = [
        %Card{rank: rank},
        %Card{rank: rank},
        %Card{rank: kicker3},
        %Card{rank: kicker2},
        %Card{rank: kicker1},
      ])
      do
    %Combo{
      type: @one_pair,
      power: {rank, kicker1, kicker2, kicker3},
      cards: cards,
    }
  end
  defp eval(cards = [
        %Card{rank: rank1},
        %Card{rank: rank2},
        %Card{rank: rank3},
        %Card{rank: rank4},
        %Card{rank: rank5},
      ])
      do
    %Combo{
      type: @high_card,
      power: {rank5, rank4, rank3, rank2, rank1},
      cards: cards,
    }
  end

end
