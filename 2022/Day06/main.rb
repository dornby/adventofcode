require_relative "data"

chars = DATA.chars

chars.each_with_index do |c, i|
  next if i < 3

  # if chars[(i - 3)..i].uniq.size == 4
  if chars[(i - 13)..i].uniq.size == 14
    @winning_index = i
    break
  end
end

p @winning_index + 1
