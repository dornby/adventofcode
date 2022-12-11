require_relative "data"

monkeys = DATA

def inspect_item(item, operation)
  old = item
  eval(operation.split("new = ")[1])
end

def relax_item(item)
  (item / 3.0).floor
end

def test_item(item, test)
  item % test.split("divisible by ")[1].to_i == 0
end

20.times do
  monkeys.each do |_monkey, monkey_stuff|

    monkey_stuff[:starting_items].each do |item|
      new_item = inspect_item(item, monkey_stuff[:operation])

      if monkey_stuff[:inspected_items_count].nil?
        monkey_stuff[:inspected_items_count] = 1
      else
        monkey_stuff[:inspected_items_count] += 1
      end

      new_item = relax_item(new_item)

      test_result = test_item(new_item, monkey_stuff[:test])

      throw_operation = monkey_stuff["if_#{test_result}".to_sym]
      throw_monkey = throw_operation.split("throw to ")[1].gsub(" ", "_").to_sym


      monkeys[throw_monkey][:starting_items].push(new_item)
    end

    monkey_stuff[:starting_items] = []
  end
end

inspected_items = monkeys.map do |monkey, monkey_stuff|
  monkey_stuff[:inspected_items_count]
end

p inspected_items.max(2).inject(:*)
