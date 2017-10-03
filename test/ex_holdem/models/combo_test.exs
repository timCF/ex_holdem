defmodule ExHoldem.ComboTest do
  use ExUnit.Case
  use ExHoldem.Constants
  @default_suit :diamonds

  setup_all do
    royal_flush_hand = [
      %Card{suit: @default_suit, rank: 8},
      %Card{suit: @default_suit, rank: 9},
      %Card{suit: @default_suit, rank: 10},
      %Card{suit: @default_suit, rank: @jack},
      %Card{suit: @default_suit, rank: @queen},
      %Card{suit: @default_suit, rank: @king},
      %Card{suit: @default_suit, rank: @ace},
    ]
    {:ok, [
      royal_flush_hand: royal_flush_hand,
      permutations_list: [1, 2, 3],
    ]}
  end

  test "permutations", %{permutations_list: permutations_list} do
    result = ExHoldem.Combo.permutations(permutations_list, 3)
    # math based number of perm
    assert 6 == length(result)
    # permutations are uniq
    assert result == Enum.uniq(result)
    # permutations elements are elements from init list
    assert  Enum.all?(result, fn(perm) ->
              Enum.all?(perm, fn(el) ->
                Enum.member?(permutations_list, el)
              end)
            end)
    # permutations elements are uniq
    assert  Enum.all?(result, fn(perm) ->
              perm == Enum.uniq(perm)
            end)
  end

  test "royal_flush", %{royal_flush_hand: royal_flush_hand} do
    assert %Combo{type: @royal_flush} = Combo.calculate(royal_flush_hand)
  end

end
