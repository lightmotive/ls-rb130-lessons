# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

require_relative 'todo_list'

class TodoListTest < MiniTest::Test
  attr_reader :list, :list_default_title, :todos, :list_default_size

  def setup
    todo1 = Todo.new('Buy milk')
    todo2 = Todo.new('Clean room')
    todo3 = Todo.new('Go to gym')
    @todos = [todo1, todo2, todo3]
    @list_default_size = todos.size

    @list_default_title = "Test Today's Todos"
    @list = TodoList.new(@list_default_title, todos)
  end

  def test_add
    add_returned = list.add(todos[0])
    assert_equal(list_default_size + 1, list.size)
    assert_same(todos.first, list.last)
    assert_instance_of(TodoList, add_returned)
  end

  def test_add_left_left
    concatenated_list = (list << todos[1])
    assert_same(concatenated_list, list)
    assert_equal(todos[1], list.last)
  end

  def test_add_exceptions
    exception = assert_raises(TypeError) { list.add(1) }
    assert_equal('Can only add Todo objects', exception.message)
  end

  def test_size
    assert_equal(list_default_size, list.size)
  end

  def test_first
    assert_same(todos.first, list.first)
  end

  def test_last
    assert_same(todos.last, list.last)
  end

  def test_to_a
    assert_equal(todos, list.to_a)
  end

  def test_done?
    refute(list.done?)
    list.each(&:done!)
    assert(list.done?)
  end

  def test_item_at
    assert_same(todos[1], list.item_at(1))
  end

  def test_item_at_exceptions
    assert_raises(ArgumentError) { list.item_at }
    assert_raises(IndexError) { list.item_at(100) }
  end

  def test_to_s_nothing_completed
    expected = <<~LIST.strip
      ---- #{list_default_title} ----
      [ ] Buy milk
      [ ] Clean room
      [ ] Go to gym
    LIST
    assert_equal(expected, list.to_s)
  end

  def test_to_s_one_completed
    list.mark_done_at(1)

    expected = <<~LIST.strip
      ---- #{list_default_title} ----
      [ ] Buy milk
      [X] Clean room
      [ ] Go to gym
    LIST
    assert_equal(expected, list.to_s)
  end

  def test_each_enumeration_and_return_value
    each_return_val = list.each_with_index do |todo, idx|
      assert_same(todos[idx], todo)
    end
    assert_instance_of(TodoList, each_return_val)
  end

  def test_mark_done_at
    list.mark_done_at(1)
    assert(todos[1].done?)
  end

  def test_mark_done_at_exceptions
    assert_raises(ArgumentError) { list.mark_done_at }
    assert_raises(IndexError) { list.mark_done_at(100) }
  end

  def test_select
    list.mark_done_at(1)
    selected = list.select(&:done?)
    assert_instance_of(TodoList, selected)
    assert_equal(1, selected.size)
    assert_same(todos[1], selected.first)
  end

  def test_find_by_title
    assert_same(todos.last, list.find_by_title(todos.last.title))
  end

  def test_all_done
    assert_empty(list.all_done)
    list.done!
    assert_equal(todos, list.to_a)
  end

  def test_all_not_done
    assert_equal(todos, list.all_not_done.to_a)
  end

  def test_mark_undone_at
    list.done!
    list.mark_undone_at(1)
    refute(todos[1].done?)
  end

  def test_mark_undone_at_exceptions
    assert_raises(ArgumentError) { list.mark_undone_at }
    assert_raises(IndexError) { list.mark_undone_at(100) }
  end

  def test_mark_done
    assert_same(todos.first, list.mark_done(todos.first.title))
    assert(todos.first.done?)
    assert_nil(list.mark_done('vjlas8d77j'))
  end

  def test_done!
    list.done!
    assert(todos.all?(&:done?))
    assert(list.done?)
  end

  def test_mark_all_undone
    list.mark_all_undone
    assert(todos.none?(&:done?))
  end

  def test_mark_all_done
    list.mark_all_done
    assert(list.done?)
  end

  def test_remove_at
    removed_todo = list.remove_at(1)
    assert_same(todos[1], removed_todo)
  end

  def test_remove_at_exceptions
    assert_raises(ArgumentError) { list.remove_at }
    assert_raises(IndexError) { list.remove_at(100) }
  end

  def test_shift
    shifted_todo = list.shift
    assert_same(todos.first, shifted_todo)
    assert_equal(list_default_size - 1, list.size)
  end

  def test_pop
    popped_todo = list.pop
    assert_same(todos.last, popped_todo)
    assert_equal(list_default_size - 1, list.size)
  end
end
