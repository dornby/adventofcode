require_relative "data"
require "json"

pairs = [[]]

DATA.each do |line|
  if line == ""
    pairs.push([])
  else
    pairs.last.push(JSON.parse(line))
  end
end

def comparison_output(parent_one, parent_two, child_one, child_two, index)
  return true if child_one.nil?
  return false if child_two.nil?

  if child_one.is_a?(Integer) && child_two.is_a?(Integer)
    if child_one == child_two
      return true if parent_one[index + 1].nil? && !parent_two[index + 1].nil?
      return false if !parent_one[index + 1].nil? && parent_two[index + 1].nil?
      comparison_output(parent_one, parent_two, parent_one[index + 1], parent_two[index + 1], index + 1)
    else
      return child_one < child_two
    end
  elsif child_one.is_a?(Array) && child_two.is_a?(Integer)
    comparison_output(parent_one, parent_two, child_one, [child_two], 0)
  elsif child_one.is_a?(Integer) && child_two.is_a?(Array)
    comparison_output(parent_one, parent_two, [child_one], child_two, 0)
  elsif child_one == child_two
    comparison_output(parent_one, parent_two, parent_one[index + 1], parent_two[index + 1], index + 1)
  else
    comparison_output(child_one, child_two, child_one.first, child_two.first, 0)
  end
end

good_indices = pairs.map.with_index do |pair, pair_index|
  packet_one = pair.first
  packet_two = pair.last

  comparison_output(packet_one, packet_two, packet_one.first, packet_two.first, 0) ? pair_index + 1 : nil
end.compact

p good_indices.sum
