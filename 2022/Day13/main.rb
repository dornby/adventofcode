require_relative "data"
require "json"

packets = DATA.reject { |line| line == "" }.map { |line| JSON.parse(line) }

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
    comparison_output(parent_one, parent_two, child_one, [child_two], index)
  elsif child_one.is_a?(Integer) && child_two.is_a?(Array)
    comparison_output(parent_one, parent_two, [child_one], child_two, index)
  elsif child_one == child_two
    comparison_output(parent_one, parent_two, parent_one[index + 1], parent_two[index + 1], index + 1)
  else
    comparison_output(child_one, child_two, child_one.first, child_two.first, 0)
  end
end

packets_to_pick = packets.dup

packets_to_pick.each_with_index do |packet_to_pick, i|
  packets.delete(packet_to_pick)

  index_for_insertion = nil

  packets.each_with_index do |packet, index|
    if comparison_output(packet_to_pick, packet, packet_to_pick.first, packet.first, 0)
      index_for_insertion = index
      break
    else
      next
    end
  end

  if index_for_insertion
    packets.insert(index_for_insertion, packet_to_pick)
  else
    packets.push(packet_to_pick)
  end
end

p (packets.index([[2]]) + 1) * (packets.index([[6]]) + 1)
