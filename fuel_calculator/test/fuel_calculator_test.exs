defmodule FuelCalculatorTest do
  use ExUnit.Case
  doctest FuelCalculator
  doctest FuelCalculator.Solution

  test "mass of 14 requires 2 fuel" do
    assert FuelCalculator.required_fuel(14) == 2
  end

  test "mass of 1969 requires 966 fuel" do
    assert FuelCalculator.required_fuel(1969) == 966
  end

  test "solution requires 4890696 fule" do
  	assert FuelCalculator.Solution.required_fuel!("resources/input.txt") == 4890696
  end
end
