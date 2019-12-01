defmodule FuelCalculator.Solution do
  @moduledoc """
  Solution calculator for: https://adventofcode.com/2019/day/1
  Solves part 2
  """

  @doc """
  Calculates required fuel given an input file path containing masses
  separated by newlines

  ## Examples

    iex> FuelCalculator.Solution.required_fuel!("resources/test.txt")
    50348
  """
  def required_fuel!(path) do
    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> FuelCalculator.required_fuel
  end
end