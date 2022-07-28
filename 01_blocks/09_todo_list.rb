# frozen_string_literal: true

require 'forwardable'

# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.
class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description = '')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(other)
    title == other.title &&
      description == other.description &&
      done == other.done
  end
end

# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.
class TodoList
  extend Forwardable

  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
    raise TypeError, 'Can only add Todo objects' unless todo.instance_of?(Todo)

    todos.push(todo)

    self
  end

  def done?
    todos.all?(&:done?)
  end

  alias << add

  private

  attr_reader :todos

  def_delegators :@todos, :size, :first, :last, :to_a
end

# given
todo1 = Todo.new('Buy milk')
todo2 = Todo.new('Clean room')
todo3 = Todo.new('Go to gym')
list = TodoList.new("Today's Todos")

# Helper method to test whether exception is raised
def exception?(expected_class, expected_message = nil)
  yield
  false
rescue expected_class => e
  true && (!expected_message.nil? && e.message == expected_message)
end

# ---- Adding to the list -----

# add
list.add(todo1)                 # adds todo1 to end of list, returns list
list.add(todo2)                 # adds todo2 to end of list, returns list
p exception?(TypeError, 'Can only add Todo objects') { list.add(1) }

# <<
# same behavior as add
concatenated_list = (list << todo3)
p concatenated_list == list

# ---- Interrogating the list -----

# size
p list.size == 3

# first
p list.first == todo1

# last
p list.last == todo3

# to_a
p list.to_a == [todo1, todo2, todo3]

# done?
p list.done? == false

# ---- Retrieving an item in the list ----

# item_at
p exception?(ArgumentError) { list.item_at }
p list.item_at(1) == todo2
p exception?(IndexError) { list.item_at(100) }

# to_s
p(list.to_s == <<~LIST.strip
  ---- Today's Todos ----
  [ ] Buy milk
  [ ] Clean room
  [ ] Go to gym
LIST
 )

# ---- Marking items in the list -----

# mark_done_at
p exception?(ArgumentError) { list.mark_done_at }
list.mark_done_at(1)
p todo2.done?
p exception?(IndexError) { list.mark_done_at(100) }

# to_s
p(list.to_s == <<~LIST.strip
  ---- Today's Todos ----
  [ ] Buy milk
  [X] Clean room
  [ ] Go to gym
LIST
 )

# mark_undone_at
p exception?(ArgumentError) { list.mark_undone_at }
list.mark_undone_at(1)
p !todo2.done?
p exception?(IndexError) { list.mark_undone_at(100) }

# done!
list.done! # marks all items as done
p [todo1, todo2, todo3].all?(&:done?)

# ---- Deleting from the list -----

# remove_at
p exception?(ArgumentError) { list.remove_at }
removed_todo = list.remove_at(1) # removes and returns the 2nd item
p removed_todo == todo2
p exception?(IndexError) { list.remove_at(100) }

# shift
shifted_todo = list.shift # removes and returns the first item in list
p shifted_todo == todo1
p list.size == 2

# pop
popped_todo = list.pop # removes and returns the last item in list
p popped_todo == todo3
