require_relative "data"

sand_blocks = DATA.map do |sand_block|
  sand_block_points = sand_block.split(" -> ")
  sand_block_points = sand_block_points.map do |sbp|
    sbp.split(",").map(&:to_i)
  end
end

min_x = sand_blocks.flatten(1).map(&:first).min
max_x = sand_blocks.flatten(1).map(&:first).max
max_y = sand_blocks.flatten(1).map(&:last).max

grid_x = (min_x..max_x).to_a
grid_y = (0..max_y).to_a

positions = grid_x.map { |x| grid_y.map { |y| "#{x}.#{y}" } }.flatten

elements = {}

positions.each do |position|
  if position == "500.0"
    elements[position] = "+"
  else
    elements[position] = "."
  end
end

sand_blocks.each do |sand_block|
  sand_block.each_with_index do |sand_block_point, sbp_i|
    following_sand_block_point = sand_block[sbp_i + 1]
    next if following_sand_block_point.nil?

    if sand_block_point[0] == following_sand_block_point[0]
      fill_ys = [sand_block_point[1], following_sand_block_point[1]]
      fill_ys = (fill_ys.min..fill_ys.max)
      fill_ys.each do |fill_y|
        elements["#{sand_block_point[0]}.#{fill_y}"] = "#"
      end
    elsif sand_block_point[1] == following_sand_block_point[1]
      fill_xs = [sand_block_point[0], following_sand_block_point[0]]
      fill_xs = (fill_xs.min..fill_xs.max)
      fill_xs.each do |fill_x|
        elements["#{fill_x}.#{sand_block_point[1]}"] = "#"
      end
    end
  end
end

starting_position = elements.key("+")
starting_position_x = starting_position.split(".")[0].to_i
starting_position_y = starting_position.split(".")[1].to_i
starting_position = [starting_position_x, starting_position_y]

void = false

def get_next_position_from(sand_position, elements, max_y)
  bottom_position = [sand_position[0], sand_position[1] + 1]
  if ["#", "o"].include?(elements[bottom_position.join(".")])
    bottom_left_position = [sand_position[0] - 1, sand_position[1] + 1]
    if ["#", "o"].include?(elements[bottom_left_position.join(".")])
      bottom_right_position = [sand_position[0] + 1, sand_position[1] + 1]
      if ["#", "o"].include?(elements[bottom_right_position.join(".")])
        return sand_position
      else
        get_next_position_from(bottom_right_position, elements, max_y)
      end
    else
      get_next_position_from(bottom_left_position, elements, max_y)
    end
  elsif bottom_position[1] > max_y
    return "void"
  else
    get_next_position_from(bottom_position, elements, max_y)
  end
end

while !void
  final_position = get_next_position_from(starting_position, elements, max_y)

  if final_position == "void"
    void = true
  else
    elements[final_position.join(".")] = "o"
  end
end

p elements.values.select { |v| v == "o" }.count
