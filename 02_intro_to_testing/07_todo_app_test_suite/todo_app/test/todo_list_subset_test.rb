# frozen_string_literal: true

require_relative 'test_helper'
require './lib/todo_list_subset'
require_relative 'todo_list_test_core'

class TodoListSubsetTest < TodoListTestCore
  attr_reader :list_subset, :list_subset_default_title, :todos_subset

  def setup
    super

    @list_subset_default_title = 'Subset Title'
    @todos_subset = [todos[1]]
    @list_subset = TodoListSubset.new(list, list_subset_default_title, todos_subset)
  end

  def test_contents
    assert_equal(todos_subset, list_subset.to_a)
  end

  def test_inheritance
    assert_kind_of(TodoList, list_subset)
  end

  def test_title
    assert_equal("#{list.title} / #{list_subset_default_title}", list_subset.title)
  end
end
