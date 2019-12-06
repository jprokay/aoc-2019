# PasswordSolver

**Solves Advent of Code: Day 4**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `password_solver` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:password_solver, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/password_solver](https://hexdocs.pm/password_solver).

## To Solve on an Input
Note: This will only solve Part 2
```elixir
iex> PasswordSolver.valid_passwords_count(165432..707912)
1163
```