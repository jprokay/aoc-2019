defmodule FuelCalculator do
  @moduledoc """
  Calculates needed fuel to launch a module.
  https://adventofcode.com/2019/day/1
  """

  @doc """
  Calculates required fuel for a given mass.
  ## Examples

      iex> FuelCalculator.required_fuel(14)
      2
      iex> FuelCalculator.required_fuel(1969)
      966
  """
  def required_fuel(mass) when is_integer(mass) and mass > 0 do
    required_fuel(mass, 0)
  end

  def required_fuel(mass) when is_integer(mass) and mass <= 0 do
    0
  end

  @doc """
  Calculates required fuel for a Stream of masses.
  ## Examples

      iex> FuelCalculator.required_fuel([14, 1969])
      968
  """
  def required_fuel(masses) do
    masses
    |> Stream.map(&required_fuel/1)
    |> Enum.sum
  end

  defp required_fuel(mass, total) when mass <= 0 do
    total
  end

  defp required_fuel(mass, total) when mass > 0 do
    needed = Integer.floor_div(mass, 3) - 2
    required_fuel(needed, sum(needed, total))
  end

  defp sum(mass, total) when mass > 0 do
    mass + total
  end

  defp sum(mass, total) when mass <= 0 do
    total
  end
end
