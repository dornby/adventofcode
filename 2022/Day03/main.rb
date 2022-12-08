require_relative "data"

LETTERS_BY_PRIORITY = ("a".."z").to_a + ("A".."Z").to_a

# points = DATA.map do |rucksack|
#   compartment_size = rucksack.size / 2
#   first_compartment_items = rucksack.chars.first(compartment_size)
#   second_compartment_items = rucksack.chars.last(compartment_size)

#   common_item = (first_compartment_items & second_compartment_items).first
#   LETTERS_BY_PRIORITY.index(common_item) + 1
# end

# p points.sum

groups = DATA.each_slice(3).to_a

badges = groups.map do |group|
  first_rucksack_items = group[0].chars
  second_rucksack_items = group[1].chars
  third_rucksack_items = group[2].chars

  badge = (first_rucksack_items & second_rucksack_items & third_rucksack_items).first
  LETTERS_BY_PRIORITY.index(badge) + 1
end

p badges.sum
