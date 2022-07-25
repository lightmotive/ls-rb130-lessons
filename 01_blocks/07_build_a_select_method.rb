# frozen_string_literal: true

def select(from_array_like_collection)
  selected = []

  from_array_like_collection.each do |element|
    selected << element if yield(element)
  end

  selected
end

p select((1..5).to_a, &:odd?)
# => [1, 3, 5]

p select(1..5, &:even?)
# => [2, 4]
