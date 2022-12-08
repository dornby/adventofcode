require_relative "data"

def range_from(section_text)
  extremities = section_text.split("-")
  (extremities.first.to_i)..(extremities.last.to_i)
end

# def overlap?(first_range, second_range)
#   first_range.min <= second_range.min &&
#     first_range.max >= second_range.max
# end

def overlap?(first_range, second_range)
  first_range.max >= second_range.min &&
    first_range.min <= second_range.max
end

overlaps = DATA.map do |pair|
  ranges = pair.split(",")
  first_range_text = ranges[0]
  second_range_text = ranges[1]

  first_range = range_from(first_range_text)
  second_range = range_from(second_range_text)

  overlap?(first_range, second_range) || overlap?(second_range, first_range)
end.select(&:itself)

p overlaps.count
