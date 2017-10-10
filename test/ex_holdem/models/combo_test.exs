defmodule ExHoldem.ComboTest.MacroHelper do
  use ExHoldem.Constants
  #
  # NOTE: test for 1 combo evaluates ~ 70 sec!!!
  #
  defmacro build_wincombo_tests do
    [
      :royal_flush ,
      :straight_flush,
      :four,
      :full_house,
      :flush,
      :straight,
      :three,
      :two_pairs,
      :one_pair,
      :high_card,
    ]
    |> Enum.reduce(quote do end, fn(combo_atom, acc) ->
      quote do
        unquote(acc)
        @tag timeout: :timer.hours(1)
        test unquote(Atom.to_string(combo_atom)), %{hands: %{unquote(combo_atom) => hand}} do
          assert  hand
                  |> ExHoldem.Combo.permutations(7)
                  |> Enum.all?(fn(hand_perm) ->
                    %Combo{type: combo_type} = Combo.calculate(hand_perm)
                    combo_type == unquote({:@, [], [{combo_atom, [], nil}]})
                  end)
        end
      end
    end)
  end
end

defmodule ExHoldem.ComboTest do
  use ExUnit.Case
  use ExHoldem.Constants

  setup_all do
    royal_flush_hand = [
      %Card{suit: @diamonds, rank: 8},
      %Card{suit: @diamonds, rank: 9},
      %Card{suit: @diamonds, rank: 10},
      %Card{suit: @diamonds, rank: @jack},
      %Card{suit: @diamonds, rank: @queen},
      %Card{suit: @diamonds, rank: @king},
      %Card{suit: @diamonds, rank: @ace},
    ]
    straight_flush_hand = [
      %Card{suit: @diamonds, rank: 7},
      %Card{suit: @diamonds, rank: 8},
      %Card{suit: @diamonds, rank: 9},
      %Card{suit: @diamonds, rank: 10},
      %Card{suit: @diamonds, rank: @jack},
      %Card{suit: @diamonds, rank: @queen},
      %Card{suit: @diamonds, rank: @king},
    ]
    four_hand = [
      %Card{suit: @diamonds, rank: 7},
      %Card{suit: @diamonds, rank: 8},
      %Card{suit: @diamonds, rank: 9},
      %Card{suit: @hearts, rank: @king},
      %Card{suit: @diamonds, rank: @king},
      %Card{suit: @spades, rank: @king},
      %Card{suit: @clubs, rank: @king},
    ]
    full_house_hand = [
      %Card{suit: @diamonds, rank: 7},
      %Card{suit: @diamonds, rank: 8},
      %Card{suit: @diamonds, rank: @queen},
      %Card{suit: @hearts, rank: @queen},
      %Card{suit: @diamonds, rank: @king},
      %Card{suit: @spades, rank: @king},
      %Card{suit: @clubs, rank: @king},
    ]
    flush_hand = [
      %Card{suit: @spades, rank: 2},
      %Card{suit: @clubs, rank: 4},
      %Card{suit: @diamonds, rank: 6},
      %Card{suit: @diamonds, rank: 8},
      %Card{suit: @diamonds, rank: @jack},
      %Card{suit: @diamonds, rank: @ace},
      %Card{suit: @diamonds, rank: @king},
    ]
    straight_hand = [
      %Card{suit: @spades, rank: 7},
      %Card{suit: @clubs, rank: 8},
      %Card{suit: @diamonds, rank: 9},
      %Card{suit: @hearts, rank: 10},
      %Card{suit: @spades, rank: @jack},
      %Card{suit: @clubs, rank: @queen},
      %Card{suit: @diamonds, rank: @king},
    ]
    three_hand = [
      %Card{suit: @diamonds, rank: 7},
      %Card{suit: @diamonds, rank: 8},
      %Card{suit: @diamonds, rank: 2},
      %Card{suit: @hearts, rank: 4},
      %Card{suit: @diamonds, rank: @king},
      %Card{suit: @spades, rank: @king},
      %Card{suit: @clubs, rank: @king},
    ]
    two_pairs_hand = [
      %Card{suit: @diamonds, rank: 7},
      %Card{suit: @diamonds, rank: 8},
      %Card{suit: @diamonds, rank: @queen},
      %Card{suit: @hearts, rank: @queen},
      %Card{suit: @diamonds, rank: @king},
      %Card{suit: @spades, rank: @king},
      %Card{suit: @clubs, rank: 2},
    ]
    one_pair_hand = [
      %Card{suit: @diamonds, rank: 7},
      %Card{suit: @diamonds, rank: 8},
      %Card{suit: @diamonds, rank: @queen},
      %Card{suit: @hearts, rank: @queen},
      %Card{suit: @diamonds, rank: 10},
      %Card{suit: @spades, rank: 4},
      %Card{suit: @clubs, rank: 2},
    ]
    high_card_hand = [
      %Card{suit: @diamonds, rank: 7},
      %Card{suit: @diamonds, rank: 8},
      %Card{suit: @diamonds, rank: @queen},
      %Card{suit: @hearts, rank: 3},
      %Card{suit: @diamonds, rank: 10},
      %Card{suit: @spades, rank: 4},
      %Card{suit: @clubs, rank: 2},
    ]

    {:ok, [
      hands: %{
        royal_flush: royal_flush_hand,
        straight_flush: straight_flush_hand,
        four: four_hand,
        full_house: full_house_hand,
        flush: flush_hand,
        straight: straight_hand,
        three: three_hand,
        two_pairs: two_pairs_hand,
        one_pair: one_pair_hand,
        high_card: high_card_hand
      },
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

  require ExHoldem.ComboTest.MacroHelper
  ExHoldem.ComboTest.MacroHelper.build_wincombo_tests()

end
