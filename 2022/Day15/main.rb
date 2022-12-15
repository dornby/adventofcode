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

device_positions = sensor_positions + beacon_positions

min_x = device_positions.map(&:first).min
max_x = device_positions.map(&:first).max
min_y = device_positions.map(&:last).min
max_y = device_positions.map(&:last).max

def get_manhattan_distance_from_pair(pair)
  pair_xs = pair.map(&:first)
  pair_ys = pair.map(&:last)

  x_distance = (pair_xs[1] - pair_xs[0]).abs
  y_distance = (pair_ys[1] - pair_ys[0]).abs

  x_distance + y_distance
end

check_y = 2000000
xs_without_possible_beacon = []

sensor_positions.zip(beacon_positions).each do |sensor_beacon_pair|
  manhattan = get_manhattan_distance_from_pair(sensor_beacon_pair)
  sensor_position = sensor_beacon_pair[0]
  sensor_x = sensor_position[0]
  sensor_y = sensor_position[1]
  distance_sensor_check_y = (sensor_y - check_y).abs
  left_manhattan_distance_for_x = manhattan - distance_sensor_check_y
  block_xs = ((sensor_x - left_manhattan_distance_for_x)..(sensor_x + left_manhattan_distance_for_x)).to_a
  xs_without_possible_beacon += block_xs
  xs_without_possible_beacon = xs_without_possible_beacon.uniq
end

xs_without_possible_beacon -= beacon_positions.select { |bp| bp.last == check_y }.map(&:first)

p xs_without_possible_beacon.uniq.count
