defmodule ExHoldem.Deck do
  alias ExHoldem.Card
  @suits [
    :diamonds,
    :hearts,
    :spades,
    :clubs,
  ]
  # 2..10
  # J 11
  # Q 12
  # K 13
  # A 14
  def new do
    Enum.flat_map(2..14, fn(rank) ->
      Enum.map(@suits, fn(suit) ->
        %Card{
          suit: suit,
          rank: rank,
        }
      end)
    end)
    #
    # TODO : replace with crypto-strong RNG
    #
    |> Enum.shuffle
  end
end
