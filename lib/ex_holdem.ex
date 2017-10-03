defmodule ExHoldem.Constants do
  defmacro __using__(_) do
    quote do
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

      alias ExHoldem.{Card, Combo, Game, Deck}

    end
  end
end

defmodule ExHoldem do

  @moduledoc """
  Documentation for ExHoldem.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ExHoldem.hello
      :world

  """
  def hello do
    :world
  end
end
