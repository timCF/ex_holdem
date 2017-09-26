defmodule ExHoldem.Combo do

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
          true -> (length1 < length2)
        end
      end)
      |> Enum.map(fn({_, cards = [_|_]}) -> cards end)
      |> List.flatten
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

  @royal_flush 10
  @straight_flush 9
  @four 8
  @full_house 7
  @flush 6
  @straight 5
  @three 4
  @two_pairs 3
  @one_pair 2
  @high_card 1

  @jack 11
  @queen 12
  @king 13
  @ace 14

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
        %Card{rank: kicker},
        %Card{rank: rank},
        %Card{rank: rank},
        %Card{rank: rank},
        %Card{rank: rank},
      ])
      do
    %Combo{
      type: @four,
      power: {rank, kicker},
      cards: cards,
    }
  end


end
