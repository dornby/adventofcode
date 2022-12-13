require_relative "data"

def target_letter_for_position(line_index, column_index, grid)
  letter = grid[line_index][column_index]

  if letter == "S"
    letter = "a"
  elsif letter == "E"
    letter = "z"
  end

  letter
end

grid = DATA.map { |line| line.chars }

alphabet = ("a".."z").to_a

ending_line = grid.index { |line| line.include?("E") }
ending_column = grid[ending_line].index { |column| column == "E" }
ending_position = "#{ending_line}.#{ending_column}"

positions = {}

existing_positions = grid.map.with_index { |line, li| line.map.with_index { |_c, ci| "#{li}.#{ci}" } }.flatten

existing_positions.each do |position|
  line_index = position.split(".")[0].to_i
  column_index = position.split(".")[1].to_i

  left_to_position = column_index == 0 ? nil : column_index - 1
  if !left_to_position.nil?
    left_to_position = "#{line_index}.#{left_to_position}"
  end

  right_to_position = column_index == (grid[0].size - 1) ? nil : column_index + 1
  if !right_to_position.nil?
    right_to_position = "#{line_index}.#{right_to_position}"
  end

  up_to_position = line_index == 0 ? nil : line_index - 1
  if !up_to_position.nil?
    up_to_position = "#{up_to_position}.#{column_index}"
  end

  down_to_position = line_index == (grid.size - 1) ? nil : line_index + 1
  if !down_to_position.nil?
    down_to_position = "#{down_to_position}.#{column_index}"
  end

  possible_next_positions = [left_to_position, right_to_position, up_to_position, down_to_position].compact

  position_letter = target_letter_for_position(line_index, column_index, grid)
  alphabet_index_for_position = alphabet.index(position_letter)

  possible_letters = alphabet[0..alphabet_index_for_position + 1]
  positions[position] = possible_next_positions.select { |pnp| possible_letters.include?(target_letter_for_position(pnp.split(".")[0].to_i, pnp.split(".")[1].to_i, grid)) }
end

starting_positions = existing_positions.select { |ep| target_letter_for_position(ep.split(".")[0].to_i, ep.split(".")[1].to_i, grid) == "a" }
rounds = []

starting_positions.each do |starting_position|
  queue = []
  visited = []
  queue += [starting_position]

  previous_positions = {}

  positions.keys.each do |position|
    previous_positions[position] = nil
  end

  while !queue.empty?
    node_to_visit = queue.first

    not_visited_neighbours = (positions[node_to_visit] - visited)

    not_visited_neighbours.each do |not_visited_neighbour|
      previous_positions[not_visited_neighbour] = node_to_visit
    end

    queue.delete(node_to_visit)
    visited.push(node_to_visit)

    queue += not_visited_neighbours

    break if visited.include?(ending_position)
  end

  round = 0

  previous_pos = previous_positions[ending_position]
  next if previous_pos.nil?

  while !previous_pos.nil?
    round += 1
    previous_pos = previous_positions[previous_pos]
  end

  rounds.push(round)
end

p rounds.min

