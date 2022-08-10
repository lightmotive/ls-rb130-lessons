# frozen_string_literal: true

require './lib/todo_list'

class TodoListTestCore < MiniTest::Test
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
end
