defmodule CrossedWires do
  @origin %Line.Point{x: 0, y: 0}
  @moduledoc """
  Documentation for CrossedWires.
  """

  @doc """
  Hello world.

  ## Examples

      iex> CrossedWires.hello()
      :world

  """
  def min_manhattan(wire1, wire2) do
    all_intersections(wire1, wire2)
    |> minimum_manhattan
  end

  def all_intersections(wire1, wire2) do
    wire1
    |> Enum.flat_map(&(intersections(&1, wire2)))
    |> remove_invalid_intersections
  end

  defp intersections(line, lines) do
    lines
    |> Enum.map(&(Line.intersection(&1, line)))
    |> Enum.filter(fn {res, point} -> res == :ok and point != %{} end)
    |> Enum.map(fn {_, point} -> point end)
  end

  def min_signal_delay(wire1, wire2) do
    all_intersections(wire1, wire2)
    |> min_signal_delay(wire1, wire2)
  end
  
  defp min_signal_delay(intersections, wire1, wire2) do
    intersections
    |> Enum.reduce(%{}, fn point, acc ->
      w1_delay = Wire.signal_delay(wire1, point)
      w2_delay = Wire.signal_delay(wire2, point)
      Map.put(acc, point, w1_delay + w2_delay)
    end)
    |> Map.values
    |> Enum.min
  end

  defp minimum_manhattan(points) do
    points
    |> Enum.map(fn p -> Line.Point.manhattan_distance(@origin, p) end)
    |> Enum.min
  end

  defp remove_invalid_intersections(points) do
    points
    |> Enum.filter(fn point -> point != @origin end)
  end
end

defmodule CrossedWires.File do
  @origin %Line.Point{x: 0, y: 0}
  @origin_line %Line{point1: @origin, point2: @origin}

  @doc """
  Converts an input file into arrays of Lines

  """
  def convert!(path) do
    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&(String.split(&1, ",")))
    |> Enum.map(&(convert_instructions(&1)))
  end

  defp convert_instructions(line) do
    line
    |> Enum.reduce([@origin_line],
      fn x, acc ->
        start =
          Enum.reverse(acc)
          |> Enum.at(-1) # Get the last point
          |> Map.get(:point2) # Always build off the end of the last line
        line = CrossedWires.InstructionLine.convert(x, start)
        [line | acc]
      end)
    |> Enum.slice(0..-2) # Remove origin line
  end
end

defmodule CrossedWires.InstructionLine do
  @right "R"
  @up "U"
  @left "L"
  @down "D"

  @doc """
  Converts a string that builds a line into a Line
  consisting of two points

  ## Examples
    iex> CrossedWires.InstructionLine.convert("U10",  %Line.Point{x: 0, y: 0})
    %Line{point1:  %Line.Point{x: 0, y: 0}, point2:  %Line.Point{x: 0, y: 10}, value: 10}
    iex> CrossedWires.InstructionLine.convert("D10",  %Line.Point{x: 5, y: 5})
    %Line{point1:  %Line.Point{x: 5, y: 5}, point2:  %Line.Point{x: 5, y: -5}, value: 10}
  """
  def convert(line, start) do
    {instruction, amount} = String.split_at(line, 1)
    amount = String.to_integer(amount)

    p1 = start
    p2 = perform(instruction, amount, start)

    %Line{point1: p1, point2: p2, value: amount}
  end

  defp perform(@up, amount, start) do
    Map.put(start, :y, Map.get(start, :y) + amount)
  end

  defp perform(@down, amount, start) do
    Map.put(start, :y, Map.get(start, :y) - amount)
  end

  defp perform(@left, amount, start) do
    Map.put(start, :x, Map.get(start, :x) - amount)
  end

  defp perform(@right, amount, start) do
    Map.put(start, :x, Map.get(start, :x) + amount)
  end
end