# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

require_relative 'todo_list'

class TodoListTest < MiniTest::Test
  # ...
end

# Tests to migrate to associated test files...
#
# given
# todo1 = Todo.new('Buy milk')
# todo2 = Todo.new('Clean room')
# todo3 = Todo.new('Go to gym')
# list = TodoList.new("Today's Todos")
#
# Helper method to test whether exception is raised
# def exception?(expected_class, expected_message = nil)
#   yield
#   false
# rescue expected_class => e
#   return true if expected_message.nil?
#
#   e.message == expected_message
# end
#
# ---- Adding to the list -----
# puts '*** Add ***'
#
# add
# list.add(todo1)                 # adds todo1 to end of list, returns list
# list.add(todo2)                 # adds todo2 to end of list, returns list
# p exception?(TypeError, 'Can only add Todo objects') { list.add(1) }
#
# <<
# same behavior as add
# concatenated_list = (list << todo3)
# p concatenated_list == list
#
# ---- Interrogating the list -----
# puts '*** Interrogate ***'
#
# size
# p list.size == 3
#
# first
# p list.first == todo1
#
# last
# p list.last == todo3
#
# to_a
# p list.to_a == [todo1, todo2, todo3]
#
# done?
# p list.done? == false
#
# ---- Retrieving an item in the list ----
# puts '*** Retrieve ***'
#
# item_at
# p exception?(ArgumentError) { list.item_at }
# p list.item_at(1) == todo2
# p exception?(IndexError) { list.item_at(100) }
#
# to_s
# p(list.to_s == <<~LIST.strip
#   ---- Today's Todos ----
#   [ ] Buy milk
#   [ ] Clean room
#   [ ] Go to gym
# LIST
#  )
#
# puts '*** Enumerate ***'
# each_return_val = list.each_with_index do |todo, idx|
#   p(todo.to_s ==
#     case idx
#     when 0 then '[ ] Buy milk'
#     when 1 then '[ ] Clean room'
#     when 2 then '[ ] Go to gym'
#     end)
# end
# p each_return_val.instance_of?(TodoList)
#
# ---- Marking items in the list -----
#
# mark_done_at
# p exception?(ArgumentError) { list.mark_done_at }
# list.mark_done_at(1)
# p todo2.done?
# p exception?(IndexError) { list.mark_done_at(100) }
#
# to_s
# p(list.to_s == <<~LIST.strip
#   ---- Today's Todos ----
#   [ ] Buy milk
#   [X] Clean room
#   [ ] Go to gym
# LIST
#  )
#
# p(TodoListSubset.new(list, 'Sorted by Incomplete', list.sort).to_s == <<~LIST.strip
#   ---- Today's Todos / Sorted by Incomplete ----
#   [ ] Buy milk
#   [ ] Go to gym
#   [X] Clean room
# LIST
#  )
#
# puts '*** Select ***'
# selected = list.select(&:done?)
# p selected.to_a == [todo2]
#
# puts '*** Find ***'
# p list.find_by_title('Go to gym') == todo3
# p list.all_done.to_a == [todo2]
# p list.all_not_done.to_a == [todo1, todo3]
#
# puts '*** Mark ***'
# mark_undone_at
# p exception?(ArgumentError) { list.mark_undone_at }
# list.mark_undone_at(1)
# p !todo2.done?
# p exception?(IndexError) { list.mark_undone_at(100) }
# p list.mark_done('Go to gym') == todo3
# p todo3.done?
# p list.mark_done('vjlas8d77j').nil?
#
# done!
# list.done! # marks all items as done
# p [todo1, todo2, todo3].all?(&:done?)
# p list.done? == true
#
# list.mark_all_undone
# p !list.done?
# list.mark_all_done
# p list.done?
#
# ---- Deleting from the list -----
# puts '*** Delete ***'
#
# remove_at
# p exception?(ArgumentError) { list.remove_at }
# removed_todo = list.remove_at(1) # removes and returns the 2nd item
# p removed_todo == todo2
# p exception?(IndexError) { list.remove_at(100) }
#
# shift
# shifted_todo = list.shift # removes and returns the first item in list
# p shifted_todo == todo1
# p list.size == 1
#
# pop
# popped_todo = list.pop # removes and returns the last item in list
# p popped_todo == todo3
# p list.empty?
