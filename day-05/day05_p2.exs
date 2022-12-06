defmodule CrateMoving do
  # Move multiple crates at the same time
  def move_crates(state, numCrates, fromSlot, toSlot) do
    Enum.with_index(state)
    |> Enum.map(fn {slots, index} ->
      cond do
        index == fromSlot ->
          Enum.slice(slots, numCrates..(length(slots) - 1))

        index == toSlot ->
          Enum.concat(Enum.slice(Enum.at(state, fromSlot), 0..(numCrates - 1)), slots)

        true ->
          slots
      end
    end)
  end

  # Apply state creation lines to create an initial state
  def construct_initial_state(initial_state_lines, num_stacks) do
    parsed_initial_state_lines =
      initial_state_lines
      |> Enum.map(fn line -> parse_state_creation_line(line, num_stacks) end)

    for i <- 0..(num_stacks - 1) do
      parsed_initial_state_lines
      |> Enum.map(fn state_line -> Enum.at(state_line, i) end)
      |> Enum.filter(fn item -> item != " " end)
    end
  end

  # Gets the number line that labels the crates
  def get_number_line(lines) do
    if(length(lines) == 0) do
      nil
    else
      line = List.first(lines)

      if(not String.contains?(line, "[")) do
        line
      else
        get_number_line(List.delete_at(lines, 0))
      end
    end
  end

  # Gets the initial crate configuration lines
  def get_initial_state_lines(lines, accumlated_lines) do
    if(length(lines) == 0) do
      nil
    else
      line = List.first(lines)

      if(String.contains?(line, "[")) do
        new_lines = List.insert_at(accumlated_lines, length(accumlated_lines), line)
        get_initial_state_lines(List.delete_at(lines, 0), new_lines)
      else
        accumlated_lines
      end
    end
  end

  # Gets the move crate lines
  def get_instruction_lines(lines) do
    if(length(lines) == 0) do
      nil
    else
      line = List.first(lines)

      if(String.contains?(line, "from")) do
        lines
      else
        get_instruction_lines(List.delete_at(lines, 0))
      end
    end
  end

  # Returns the number of stacks given a number line
  def num_stacks(number_line) do
    Integer.floor_div(String.length(number_line) + 1, 4)
  end

  # Creates a list of items from a creation line
  def parse_state_creation_line(line, numStacks) do
    for i <- 0..(numStacks - 1) do
      String.at(line, 1 + i * 4)
    end
  end

  # Parses a single instruction line
  def parse_line(line) do
    tokens = String.split(line, " ")
    ["move", numCratesStr, "from", fromSlotStr, "to", toSlotStr] = tokens

    {numCrates, _} = Integer.parse(numCratesStr)
    {fromSlot, _} = Integer.parse(fromSlotStr)
    {toSlot, _} = Integer.parse(toSlotStr)
    {numCrates, fromSlot, toSlot}
  end

  def parse_and_execute_instructions(lines, prevState) do
    if length(lines) == 0 do
      prevState
    else
      {line, nextLines} = List.pop_at(lines, 0)
      {numCrates, fromSlot, toSlot} = parse_line(line)

      nextState = move_crates(prevState, numCrates, fromSlot - 1, toSlot - 1)
      parse_and_execute_instructions(nextLines, nextState)
    end
  end
end

# Read input file
{:ok, contents} = File.read("input.txt")

# Split into lines and remove whitespace
lines = String.split(contents, "\n") |> Enum.map(fn s -> String.replace_trailing(s, "\r", "") end)

# Get the number of crates in the initial state
number_line = CrateMoving.get_number_line(lines)
num_stacks = CrateMoving.num_stacks(number_line)

# Get the line in the file related to creating the initial state
initial_state_lines = CrateMoving.get_initial_state_lines(lines, [])

# Create the initial state
initial_state = CrateMoving.construct_initial_state(initial_state_lines, num_stacks)

# Collect and execute instruction lines
instruction_lines =
  CrateMoving.get_instruction_lines(lines) |> Enum.filter(fn line -> line != "" end)

outputState = CrateMoving.parse_and_execute_instructions(instruction_lines, initial_state)

# Fetch top item of each crate stack and print it out
IO.puts(
  outputState
  |> Enum.map(fn crateStack -> List.first(crateStack) end)
  |> Enum.reduce("", fn crate, acc -> if crate == nil, do: acc <> " ", else: acc <> crate end)
)
