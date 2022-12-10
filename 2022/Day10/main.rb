require_relative "data"

cycles = []
register = 1

def draw(register, index)
  sprite = [register - 1, register, register + 1]
  sprite.include?(index) ? "#" : "."
end

DATA.each do |instruction|
  if instruction == "noop"
    cycles.push(0)
  else
    cycles.push(0)
    cycles.push(instruction.split(" ")[1].to_i)
  end
end

rows = cycles.each_slice(40).map do |cycles_slice|
  cycles_slice.map.with_index do |cycle, index|
    drawing = draw(register, index)
    register += cycle
    drawing
  end
end

joined_rows = rows.map(&:join)
image = joined_rows.join("\n")

puts image
