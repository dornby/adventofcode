require_relative "data"

sensor_positions = []
beacon_positions = []

def get_position_from_info(info)
  info = info.split(", ")
  [info[0].split("=")[1].to_i, info[1].split("=")[1].to_i]
end

DATA.each do |info_line|
  info_line = info_line.split(": closest beacon is at ")
  sensor_info = info_line[0].delete_prefix("Sensor at ")
  beacon_info = info_line[1]
  sensor_positions.push(get_position_from_info(sensor_info))
  beacon_positions.push(get_position_from_info(beacon_info))
end

def get_manhattan_distance_from_pair(pair)
  pair_xs = pair.map(&:first)
  pair_ys = pair.map(&:last)

  x_distance = (pair_xs[1] - pair_xs[0]).abs
  y_distance = (pair_ys[1] - pair_ys[0]).abs

  x_distance + y_distance
end

sensor_beacon_pairs = sensor_positions.zip(beacon_positions)

highest_index = 4000000

winner = nil

sensor_beacon_pairs.each do |sensor_beacon_pair|
  sensor = sensor_beacon_pair.first
  sensor_x = sensor[0]
  sensor_y = sensor[1]

  outbound_manhattan = get_manhattan_distance_from_pair(sensor_beacon_pair) + 1
  reachable_ys = ([0, (sensor_y - outbound_manhattan)].max..[highest_index, (sensor_y + outbound_manhattan)].min).to_a

  reachable_ys.each do |reachable_y|
    left_manhattan_for_x = outbound_manhattan - (sensor_y - reachable_y).abs
    min_x = [0, sensor_x - left_manhattan_for_x].max
    max_x = [highest_index, sensor_x + left_manhattan_for_x].min

    [min_x, max_x].each do |testable_x|
      next unless testable_x >= 0 && testable_x <= highest_index
      testable_x_reached = sensor_beacon_pairs.any? do |sensor_beacon_pair_to_compare|
        testable_x_man = get_manhattan_distance_from_pair([sensor_beacon_pair_to_compare[0], [testable_x, reachable_y]])
        testable_x_man <= get_manhattan_distance_from_pair(sensor_beacon_pair_to_compare)
      end

      if !testable_x_reached
        winner = "#{testable_x}.#{reachable_y}"
        winner_pos = winner.split(".")
        p (winner_pos[0].to_i * highest_index) + winner_pos[1].to_i
        break
      end
    end

    break unless winner.nil?
  end
end
