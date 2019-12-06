defmodule PasswordSolver do
  @moduledoc """
  Solves Day 4 of Advent of Code

  Rules:
  It is a six-digit number.
  The value is within the range given in your puzzle input.
  Two adjacent digits are the same (like 22 in 122345).
    Part 2 addendum: Cannont be a part of a larger string of same numbers
  Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
  """

  @doc """
  Determines if a given password is valid given the rules

  ## Examples

      iex> PasswordSolver.valid?(112233)
      true
      iex> PasswordSolver.valid?(112222)
      true
      iex> PasswordSolver.valid?(123444)
      false
      iex> PasswordSolver.valid?(111122)
      true

  """
  def valid?(password) do
    tracker = %{previous: 0, increasing: true, adjacent: false,
    adjacent_values: []}

    final_state =
      password
      |> Integer.digits
      |> Enum.reduce_while(tracker, fn x, acc ->
          prev = acc[:previous]
          adj = adjacent?(prev, x)
          increasing = increasing?(prev, x)

          cond do
            increasing == false -> {:halt, %{acc | increasing: false}}
            adj == false -> adjacent(false, acc, x)
            adj == true ->  adjacent(true, acc, x)
          end
        end)
    # Handle the case where the last two digits are adjacent
    mod_state =
      if final_state[:adjacent] == false and Enum.count(final_state[:adjacent_values]) == 2 do
        %{final_state | adjacent: true}
      else
        final_state
      end
    mod_state
    |> Map.values
    |> Enum.all?(fn x -> x != false end)
  end

  defp adjacent(false, acc, x) do
    ajds = acc[:adjacent_values]
    prev_adj = acc[:adjacent]
    count = Enum.count(ajds)
    nm = %{acc | previous: x}
    
    if count == 2  do
      {:cont, %{%{nm | adjacent: true} | adjacent_values: [x]}}
    else
      {:cont, %{%{nm | adjacent: prev_adj or false} | adjacent_values: [x]}}
    end
  end

  defp adjacent(true, acc, x) do
    nm = %{acc | previous: x}
    ajds = acc[:adjacent_values]
    {:cont, %{nm | adjacent_values: [x | ajds]}}
  end
  @doc """

  ## Examples
  
  """
  def valid_passwords_count(range) do
    range
    |> Enum.map(&valid?/1)
    |> Enum.count(fn x -> x == true end)
  end

  defp adjacent?(x, y) do
    x == y
  end

  defp increasing?(x, y) do
    x <= y
  end
end
