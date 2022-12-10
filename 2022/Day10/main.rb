require_relative "data"

cycles = []
register = 1
signal_strengths = []

DATA.each do |instruction|
  if instruction == "noop"
    cycles.push(0)
  else
    cycles.push(0)
    cycles.push(instruction.split(" ")[1].to_i)
  end
end

cycles.each_with_index do |cycle, i|
  index = i + 1
  signal_strengths << register.dup * index
  register += cycle
end

result_indexes = [20, 60, 100, 140, 180, 220]

result_signal_strenghts = result_indexes.map do |result_index|
  signal_strengths[result_index - 1]
end

p result_signal_strenghts.sum
