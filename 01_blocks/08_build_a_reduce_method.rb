# frozen_string_literal: true

# Write method...

def reduce(array, start_value = nil)
  acc = start_value.nil? ? array.first : start_value
  array = array[1..] if start_value.nil?

  array.each do |element|
    acc = yield(acc, element)
  end

  acc
end

array = [1, 2, 3, 4, 5]

p(reduce(array) { |acc, num| acc + num } == 15)
p(reduce(array, &:+) == 15) # I don't yet understand why this works!
p(reduce(array, 10) { |acc, num| acc + num } == 25)

begin
  reduce(array) { |acc, num| acc + num if num.odd? }
  p false
rescue NoMethodError
  p true
end

# Understand how #reduce(symbol) works:
p array.reduce(:+) == 15

class Something
  def initialize(value)
    @value = value
  end

  def +(*args)
    new_value = @value

    args.each do |arg|
      new_value += arg
    end

    new_value
  end
end

def extended_arg_yield(object)
  yield(object, 2, 3)
end

p extended_arg_yield(Something.new(1), &:+)
