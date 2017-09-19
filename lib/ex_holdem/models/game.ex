defmodule ExHoldem.Game do

  alias ExHoldem.Game
  defstruct deck: ExHoldem.Deck.new(),
            phase: :init, # :init | :preflop | :flop | : turn | :river
            players_hands: [], # list of lists
            table_cards: [], # list of cards
            wincombos: [] # list of combo models

  def new(hands_number) when (hands_number in 2..6) do
    %Game{
      players_hands: List.duplicate([], hands_number)
    }
  end

  def play(game = %Game{
        phase: :init,
        players_hands: players_hands
      }) do
    Enum.reduce(
      players_hands,
      %Game{game |
        players_hands: [],
        phase: :preflop
      },
      fn([], game = %Game{
        deck: [card1, card2 | rest_deck],
        players_hands: players_hands
      }) ->
        %Game{game |
          players_hands: [[card1, card2]|players_hands],
          deck: rest_deck,
        }
      end)
  end

  def play(game = %Game{
        deck: [card1, card2, card3 | rest_deck],
        table_cards: [],
        phase: :preflop,
      }) do
    %Game{game |
      deck: rest_deck,
      table_cards: [card1, card2, card3],
      phase: :flop,
    }
  end

  def play(game = %Game{
        deck: [card1 | rest_deck],
        table_cards: table_cards = [_, _, _],
        phase: :flop,
      }) do
    %Game{game |
      deck: rest_deck,
      table_cards: [card1 | table_cards],
      phase: :turn,
    }
  end

  def play(game = %Game{
        deck: [card1 | rest_deck],
        table_cards: table_cards = [_, _, _, _],
        phase: :turn,
      }) do
    %Game{game |
      deck: rest_deck,
      table_cards: [card1 | table_cards],
      phase: :river,
    }
    |> calculate_wincombos
  end

  #
  # priv
  #

  defp calculate_wincombos(%Game{
        table_cards: table_cards,
        players_hands: players_hands,
       }) do

  end


end
