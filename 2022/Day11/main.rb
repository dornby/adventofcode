require_relative "data"

def get_modulo_from(test)
  test.split("divisible by ")[1].to_i
end

monkeys = DATA
modulos_product = monkeys.map { |_m, ms| get_modulo_from(ms[:test]) }.inject(:*)

def inspect_item(item, operation, modulos_product)
  item = item % modulos_product
  old = item
  eval(operation.split("new = ")[1])
end

def test_item(item, test)
  item % get_modulo_from(test) == 0
end

10000.times do
  monkeys.each do |_monkey, monkey_stuff|

    monkey_stuff[:starting_items].each do |item|
      new_item = inspect_item(item, monkey_stuff[:operation], modulos_product)

      if monkey_stuff[:inspected_items_count].nil?
        monkey_stuff[:inspected_items_count] = 1
      else
        monkey_stuff[:inspected_items_count] += 1
      end

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
