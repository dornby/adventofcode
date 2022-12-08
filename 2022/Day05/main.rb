require_relative "data"

crates = CRATES

ORDERS.each do |order|
  split_order = order.split(" from ")
  nb_items = split_order.first.split(" ").last.to_i
  start_crate = split_order.last[0].to_i - 1
  end_crate = split_order.last[-1].to_i - 1

  # nb_items.times do
  #   supply = crates[start_crate].slice!(0)
  #   crates[end_crate].insert(0, supply)
  # end

  supplies = crates[start_crate].slice!(0..(nb_items - 1))
  crates[end_crate].insert(0, supplies)

  p crates
end

p crates.map { |crate| crate[0] }.join
