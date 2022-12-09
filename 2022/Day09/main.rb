require_relative "data"

instructions = DATA.map { |instruction| instruction.split(" ") }
# PART 1
# head_position = [0, 0]
# tail_position = [0, 0]
# visited_tail_positions = [tail_position]

# PART 2
positions = [
  [0, 0],
  [0, 0],
  [0, 0],
  [0, 0],
  [0, 0],
  [0, 0],
  [0, 0],
  [0, 0],
  [0, 0],
  [0, 0],
]

visited_tail_positions = [positions[9]]

def get_new_head_position(head_position, direction)
  if ["R", "U"].include?(direction)
    moves_to_increment = 1
  else
    moves_to_increment = -1
  end

  if ["R", "L"].include?(direction)
    head_position[0] += moves_to_increment
  else
    head_position[1] += moves_to_increment
  end

  head_position
end

def absolute_positions(tail_position, head_position)
  x_tail_position = tail_position[0]
  y_tail_position = tail_position[1]
  x_head_position = head_position[0]
  y_head_position = head_position[1]

  [
    (x_tail_position - x_head_position).abs,
    (y_tail_position - y_head_position).abs
  ].sort
end

def dont_move?(tail_position, head_position)
  tail_position == head_position ||
    absolute_positions(tail_position, head_position) == [0, 1] ||
    absolute_positions(tail_position, head_position) == [1, 1]
end

def straight_move?(tail_position, head_position)
  absolute_positions(tail_position, head_position) == [0, 2]
end

def big_diagonal_move?(tail_position, head_position)
  absolute_positions(tail_position, head_position) == [2, 2]
end

def compute_tail_based_on_head(tail_position, head_position)
  x_tail_position = tail_position[0]
  y_tail_position = tail_position[1]
  x_head_position = head_position[0]
  y_head_position = head_position[1]

  return tail_position if dont_move?(tail_position, head_position)

  if straight_move?(tail_position, head_position)
    if y_tail_position == y_head_position
      tail_position[0] += (x_head_position - x_tail_position) / 2
    else
      tail_position[1] += (y_head_position - y_tail_position) / 2
    end
  elsif big_diagonal_move?(tail_position, head_position)
    tail_position[0] += (x_head_position - x_tail_position) / 2
    tail_position[1] += (y_head_position - y_tail_position) / 2
  else
    if (x_tail_position - x_head_position).abs == 2
      tail_position[0] += (x_head_position - x_tail_position) / 2
      tail_position[1] = y_head_position
    elsif (y_tail_position - y_head_position).abs == 2
      tail_position[0] = x_head_position
      tail_position[1] += (y_head_position - y_tail_position) / 2
    end
  end

  tail_position
end

# PART 1
# instructions.each do |direction, moves|
#   moves.to_i.times do
#     head_position = get_new_head_position(head_position, direction)
#     tail_position = compute_tail_based_on_head(tail_position, head_position)
#     visited_tail_positions << tail_position.dup
#   end
# end

# PART 2
instructions.each do |direction, moves|
  moves.to_i.times do
    positions.each_with_index do |position, index|
      if index == 0
        position = get_new_head_position(position, direction)
      else
        position = compute_tail_based_on_head(position, positions[index - 1])
      end

      visited_tail_positions << position.dup if index == 9
    end

    p positions
  end
end

p visited_tail_positions.uniq.count
