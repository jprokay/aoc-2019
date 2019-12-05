# CrossedWires

**Solves Day 3 of the Advent of Code**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `crossed_wires` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:crossed_wires, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/crossed_wires](https://hexdocs.pm/crossed_wires).

## To Solve on an Input
### Part 1: Manhattan Distance
```elixir
iex> [w1, w2] = CrossedWires.convert!("resources/example.txt")
iex> CrossedWires.min_manhattan(w1, w2)
6.0
```
### Part 2: Minimum Signal Delay
```elixir
iex> [w1, w2] = CrossedWires.convert!("resources/example.txt")
iex> CrossedWires.min_signal_delay(w1, w2)
30.0
```