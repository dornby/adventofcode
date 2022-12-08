require_relative "data"

# def visible?(tree, other_trees)
#   other_trees.all? { |other_tree| other_tree < tree  }
# end

def scenic_score_for_direction(tree, other_trees)
  score_for_direction = 0

  other_trees.each do |other_tree|
    score_for_direction += 1
    break if other_tree >= tree
  end

  score_for_direction
end

grid = DATA.map(&:chars)

# trees_with_visibility = grid.map.with_index do |line, line_index|
#   line.map.with_index do |tree, column_index|
#     left_trees = line[...column_index]
#     right_trees = line[(column_index + 1)..]
#     bottom_trees = grid[(line_index + 1)..].map { |line| line[column_index] }.flatten
#     top_trees = grid[...line_index].map { |line| line[column_index] }.flatten

#     visible_on_left = visible?(tree, left_trees)
#     visible_on_right = visible?(tree, right_trees)
#     visible_on_bottom = visible?(tree, bottom_trees)
#     visible_on_top = visible?(tree, top_trees)

#     visible_on_left || visible_on_right || visible_on_bottom || visible_on_top
#   end
# end

# p trees_with_visibility.flatten.select(&:itself).count

trees_with_scenic_score = grid.map.with_index do |line, line_index|
  line.map.with_index do |tree, column_index|
    left_trees = line[...column_index].reverse
    right_trees = line[(column_index + 1)..]
    bottom_trees = grid[(line_index + 1)..].map { |line| line[column_index] }.flatten
    top_trees = grid[...line_index].map { |line| line[column_index] }.flatten.reverse

    left_scenic_score = scenic_score_for_direction(tree, left_trees)
    right_scenic_score = scenic_score_for_direction(tree, right_trees)
    bottom_scenic_score = scenic_score_for_direction(tree, bottom_trees)
    top_scenic_score = scenic_score_for_direction(tree, top_trees)

    left_scenic_score * right_scenic_score * bottom_scenic_score * top_scenic_score
  end
end

p trees_with_scenic_score.flatten.max
