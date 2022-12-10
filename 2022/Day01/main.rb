require_relative "data"

elves = [[]]

DATA.each do |calories|
  calories == "" ? elves.push([]) : elves.last.push(calories.to_i)
end

p elves.map(&:sum).max(3).sum
