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
p(array.reduce(&:+) \
  == \
  array.reduce do |memo, element|
    memo.send(:+, element)
  end)

class Something
  def initialize(value)
    @value = value
  end

  def method(*args)
    "Value: #{@value} | Args: #{args}"
  end
end

def extended_yield(*args)
  yield(*args)
end

something = Something.new(%w[a b c])
p(extended_yield(something, 1, 2, 3, &:method) \
  == \
  something.send(:method, 1, 2, 3))
# Or:
p(extended_yield(something, 1, 2, 3, &:method) \
  == \
  extended_yield(something, 1, 2, 3) do |*args|
    args.first.send(:method, *args[1..])
  end)

# `Array#reduce` should work the same way:
puts 'Works the same with Array#reduce?'
# NOTE: `reduce` accepts a symbol without first converting to Proc.
p(array.reduce(:+) \
  == \
  array.reduce do |*args|
    args.first.send(:+, *args[1..])
  end)
# Yes!

# How about something without extra args?
puts 'Works the same with single arg yield?'
bool_arr = [true, false, true]
p(bool_arr.map(&:!) \
  == \
  bool_arr.map { |*args| args.first.send(:!, *args[1..]) })
