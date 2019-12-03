defmodule Program do
  @moduledoc """
  Executes a list of commands.

  https://adventofcode.com/2019/day/2
  """
  # Interesting positions in the program
  @answer 0
  @noun 1
  @verb 2

  # Opcodes
  @add 1
  @multiply 2
  @halt 99

  # Instruction Size
  @instructionSize 4

  @doc """
  Executes a program

  ## Examples

      iex> Program.execute([1,0,0,0,99])
      [2,0,0,0,99]
      iex> Program.execute([1,1,1,4,99,5,6,0,99])
      [30, 1, 1, 4, 2, 5, 6, 0, 99]

  """
  def execute(program) do
    execute(program, 0)
  end

  defp execute(program, position) do
    case Enum.slice(program, position, @instructionSize) do
      [@halt | _] ->
        program
      [opcode | [input1 | [input2 | [out | _]]]] ->
        new_value = perform(opcode, Enum.fetch!(program, input1), Enum.fetch!(program, input2))
        updated_program = List.update_at(program, out, fn _ -> new_value end)
        execute(updated_program, position + @instructionSize)
    end
  end

  def get_answer!(program) do
    Enum.fetch!(program, @answer)
  end

  def get_noun!(program) do
    Enum.fetch!(program, @noun)
  end

  def get_verb!(program) do
    Enum.fetch!(program, @verb)
  end

  def set_verb(program, value) do
    initialize(program, @verb, value)
  end

  def set_noun(program, value) do
    initialize(program, @noun, value)
  end

  defp initialize(program, pos, value) do
    List.update_at(program, pos, fn _ -> value end)
  end

  defp perform(@add, x, y) do
    x + y
  end

  defp perform(@multiply, x, y) do
    x * y
  end
end

defmodule Program.CalcTask do
  use Task
  @moduledoc """
  Used for calculating the effects different noun+verb combinations
  have on the answer (0th position) of a program
  """

  def start_link(program) do
    GenServer.start_link(__MODULE__, :execute, [program])
  end

  @doc """
  Initializes a program with different combinations of noun and verb pairs.

  If start = 1 and enum = [1,2,3] we will test pairs [(1,1), (1,2), (1,3)]
  ## Examples

      iex> Program.CalcTask.execute(0, [0, 1], [1,0,0,0,99])
      [%{noun: 0, verb: 0, answer: 2}, %{noun: 0, verb: 1, answer: 1}]
  """
  def execute(start, enum, program) do
     Enum.map(enum, fn x ->
        program
        |> Program.set_noun(start)
        |> Program.set_verb(x)
        |> Program.execute
        |> get_solution
      end
    )
  end

  defp get_solution(program) do
    noun = Program.get_noun!(program)
    verb = Program.get_verb!(program)
    %{noun: noun, verb: verb, answer: Program.get_answer!(program)}
  end
end

defmodule Program.TargetFinder do
  use Supervisor
  @moduledoc """
  Brute Forces a program to find a target by splitting off into
  various subtasks for calculation.
  
  """

  def start_link do
    Supervisor.start_link([{Task.Supervisor, name: __MODULE__}],
      strategy: :one_for_one)
  end

  @impl true
  def init(_) do
  end

  @doc """
  Creates a bunch of CalcTasks to try out different permutations of
  nouns and verbs for a program to see if any will yield an answer
  that matches the target

  Permutations will cover the range of 0..program.length - 2
  Number of tasks spawned will also equal 0..program.length - 2

  For the below example, we will try the following (inverses, e.g. (2, 1),
  are checked but omitted for brevity):
    [(0, 1), (0, 2), (0, 3), (1, 1), (1, 2), (1, 3), (2, 3)]
  4 tasks total will be spawned in this case.
  
  ## Examples
      iex> Program.TargetFinder.start_link
      iex> Program.TargetFinder.brute_force([1,0,0,0,99], 4)
      [%{noun: 2, verb: 2, answer: 4}]
  """
  def brute_force(program, target) do
    # Dont want to modify the end of the program
    range = 0..(Enum.count(program) - 2)

    # Separate out work to each task and stream it
    Task.Supervisor.async_stream(__MODULE__, range, Program.CalcTask,
      :execute, [range, program])
    |> Stream.flat_map(fn {:ok, answers} -> answers end)
    |> Stream.filter(fn x -> is_match?(x, target) end)
    |> Enum.to_list
  end

  defp is_match?(%{answer: a, noun: _, verb: _}, target) do
    a == target
  end
end

defmodule Program.FileReader do
  @moduledoc """
  Converts an input file into a valid program
  """
  def convert!(path) do
    File.read!(path)
    |> convert
  end

   defp convert(instructions) do
    instructions
    |> String.trim
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Program.Alarm do
  @moduledoc """
  Calculates the part 1 solution for the 1202 Alarm
  """

  def solution(path) do
    last_state(path)
    |> Enum.fetch!(0)
  end

  defp last_state(path) do
    Program.FileReader.convert!(path)
    |> initialize1202
    |> Program.execute
  end

  defp initialize1202(program) do
    program
    |> Program.set_noun(12)
    |> Program.set_verb(2)
  end
end