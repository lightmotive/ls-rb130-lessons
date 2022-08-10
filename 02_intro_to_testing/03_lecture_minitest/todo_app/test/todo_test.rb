# frozen_string_literal: true

require './lib/todo'

class TodoTest < MiniTest::Test
  attr_reader :todo, :todo_default_title

  def setup
    @todo_default_title = 'Test task 1'
    @todo = Todo.new(todo_default_title)
  end

  def test_default_values
    assert_equal(todo_default_title, todo.title)
    assert_equal('', todo.description)
    assert_equal(false, todo.done?)
  end

  def test_done!
    todo.done!
    assert_equal(true, todo.done?)
  end

  def test_done?
    assert_equal(false, todo.done?)
  end

  def test_undone!
    todo.done!
    assert_equal(true, todo.done?)
    todo.undone!
    assert_equal(false, todo.done?)
  end

  def test_comparison_default
    todo_other = Todo.new('Test task other')
    assert_equal(1, todo_other.done! <=> todo)
  end

  def test_to_s
    assert_equal("[#{Todo::UNDONE_MARKER}] #{todo_default_title}", todo.to_s)
    todo.done!
    assert_equal("[#{Todo::DONE_MARKER}] #{todo_default_title}", todo.to_s)
  end

  def test_equal
    todo_other = Todo.new(todo_default_title)
    assert_equal(todo_other, todo)
  end

  def test_not_equal
    todo_other = Todo.new('Test task other')
    refute(todo == todo_other)
  end

  def test_set_title
    random_string = "Some random title #{rand(10_000)}"
    todo.title = random_string
    assert_equal(random_string, todo.title)
  end

  def test_set_description
    random_string = "Some random description #{rand(10_000)}"
    todo.description = random_string
    assert_equal(random_string, todo.description)
  end

  def test_set_done
    assert_raises(NoMethodError) { todo.done = true }
  end
end
