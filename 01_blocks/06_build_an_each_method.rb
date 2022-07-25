# frozen_string_literal: true

def each(array)
  array.size.times do |idx|
    yield array[idx]
  end
end

arr = [1, 2, 3]
each(arr) { |element| puts element }
