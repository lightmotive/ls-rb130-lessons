# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

require_relative 'todo_list'

class TodoListTest < MiniTest::Test
  attr_reader :list, :list_default_title, :todos

  def setup
    todo1 = Todo.new('Buy milk')
    todo2 = Todo.new('Clean room')
    todo3 = Todo.new('Go to gym')
    @todos = [todo1, todo2, todo3]

    @list_default_title = "Test Today's Todos"
    @list = TodoList.new(@list_default_title, todos)
  end

  def test_add
    # list.add(todo1)                 # adds todo1 to end of list, returns list
    # test that return value is instance of TodoList
    flunk('TBI...')
  end

  def test_add_left_left
    # <<
    # same behavior as add
    # concatenated_list = (list << todo3)
    # p concatenated_list == list
    flunk('TBI...')
  end

  def test_add_exceptions
    # p exception?(TypeError, 'Can only add Todo objects') { list.add(1) }
    flunk('TBI...')
  end

  def test_size
    # p list.size == 3
    flunk('TBI...')
  end

  def test_first
    # p list.first == todo1
    flunk('TBI...')
  end

  def test_last
    # p list.last == todo3
    flunk('TBI...')
  end

  def test_to_a
    # p list.to_a == [todo1, todo2, todo3]
    flunk('TBI...')
  end

  def test_done?
    # p list.done? == false
    flunk('TBI...')
  end

  def test_item_at
    # p list.item_at(1) == todo2
    flunk('TBI...')
  end

  def test_item_at_exceptions
    # p exception?(ArgumentError) { list.item_at }
    # p exception?(IndexError) { list.item_at(100) }
    flunk('TBI...')
  end

  def test_to_s
    # p(list.to_s == <<~LIST.strip
    #   ---- Today's Todos ----
    #   [ ] Buy milk
    #   [ ] Clean room
    #   [ ] Go to gym
    # LIST
    #  )
    flunk('TBI...')
    # ...mark_done_at(1)
    # p(list.to_s == <<~LIST.strip
    #   ---- Today's Todos ----
    #   [ ] Buy milk
    #   [X] Clean room
    #   [ ] Go to gym
    # LIST
    #  )
  end

  def test_each_enumeration_and_return_value
    # each_return_val = list.each_with_index do |todo, idx|
    #   p(todo.to_s ==
    #     case idx
    #     when 0 then '[ ] Buy milk'
    #     when 1 then '[ ] Clean room'
    #     when 2 then '[ ] Go to gym'
    #     end)
    # end
    # p each_return_val.instance_of?(TodoList)
    flunk('TBI...')
  end

  def test_mark_done_at
    # list.mark_done_at(1)
    # p todo2.done?
    flunk('TBI...')
  end

  def test_mark_done_at_exceptions
    # p exception?(ArgumentError) { list.mark_done_at }
    # p exception?(IndexError) { list.mark_done_at(100) }
    flunk('TBI...')
  end

  def test_select
    # selected = list.select(&:done?)
    # p selected.to_a == [todo2]
    flunk('TBI...')
  end

  def test_find_by_title
    # p list.find_by_title('Go to gym') == todo3
    flunk('TBI...')
  end

  def test_all_done
    # p list.all_done.to_a == [todo2]
    flunk('TBI...')
  end

  def test_all_not_done
    # p list.all_not_done.to_a == [todo1, todo3]
    flunk('TBI...')
  end

  def test_mark_undone_at
    # list.mark_undone_at(1)
    # p !todo2.done?
    flunk('TBI...')
  end

  def test_mark_undone_at_exceptions
    # p exception?(ArgumentError) { list.mark_undone_at }
    # p exception?(IndexError) { list.mark_undone_at(100) }
    flunk('TBI...')
  end

  def test_mark_done
    # p list.mark_done('Go to gym') == todo3
    # p todo3.done?
    # p list.mark_done('vjlas8d77j').nil?
    flunk('TBI...')
  end

  def test_done!
    # list.done! # marks all items as done
    # p [todo1, todo2, todo3].all?(&:done?)
    # p list.done? == true
    flunk('TBI...')
  end

  def test_mark_all_undone
    # list.mark_all_undone
    # p !list.done?
    flunk('TBI...')
  end

  def test_mark_all_done
    # list.mark_all_done
    # p list.done?
    flunk('TBI...')
  end

  def test_remove_at
    # removed_todo = list.remove_at(1) # removes and returns the 2nd item
    # p removed_todo == todo2
    flunk('TBI...')
  end

  def test_remove_at_exceptions
    # p exception?(ArgumentError) { list.remove_at }
    # p exception?(IndexError) { list.remove_at(100) }
    flunk('TBI...')
  end

  def test_shift
    # shifted_todo = list.shift # removes and returns the first item in list
    # p shifted_todo == todo1
    # p list.size == 1
    flunk('TBI...')
  end

  def test_pop
    # popped_todo = list.pop # removes and returns the last item in list
    # p popped_todo == todo3
    # p list.empty?
    flunk('TBI...')
  end
end
