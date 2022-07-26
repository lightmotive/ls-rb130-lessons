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
    self
  end

  def done?
    done
  end

  def undone!
    self.done = false
    self
  end

  # We need more info about how to sort items; this is a good default so `done?`
  # items move to the bottom.
  # - We could implement customizable sorting with flags that the list would
  #   set on each `Todo` object when adding items.
  #   Would there be a better way?
  def <=>(other)
    sort_value <=> other.sort_value
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(other)
    title == other.title &&
      description == other.description &&
      done == other.done
  end

  protected

  def sort_value
    done? ? 1 : 0
  end
end

# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.
class TodoList
  extend Forwardable
  include Enumerable

  attr_accessor :title

  def_delegators :@todos, :size, :first, :last, :shift, :pop, :empty?

  def initialize(title, todos = [])
    @title = title
    self.todos = todos
  end

  def add(todo)
    raise TypeError, 'Can only add Todo objects' unless todo.instance_of?(Todo)

    todos.push(todo)

    self
  end

  alias << add

  def done?
    todos.all?(&:done?)
  end

  def item_at(idx)
    todos.fetch(idx)
  end

  def mark_done_at(idx)
    item_at(idx).done!
  end

  def mark_undone_at(idx)
    item_at(idx).undone!
  end

  def done!
    todos.each(&:done!)
  end

  def remove_at(idx)
    item_at(idx)
    todos.slice!(idx)
  end

  def to_a
    todos.dup
  end

  def each(&block)
    return to_enum unless block_given?

    todos.each(&block)

    self
  end

  def select(&block)
    return enum_for(:select) unless block_given?

    todos.select(&block).each_with_object(copy_without_todos) do |todo, list_copy|
      list_copy.add(todo)
    end
  end

  def select_subset(subset_title, &block)
    TodoListSubset.new(self, subset_title, todos.select(&block).to_a)
  end

  def find_by_title(title)
    select { |todo| todo.title == title }.to_a.first
  end

  def all_done
    select(&:done?)
  end

  def all_not_done
    select { |todo| !todo.done? }
  end

  def mark_done(title)
    find_by_title(title)&.done!
  end

  def mark_all_done
    each(&:done!)
  end

  def mark_all_undone
    each(&:undone!)
  end

  def to_s
    "---- #{title} ----\n" \
    + todos.map(&:to_s).join("\n")
  end

  private

  attr_reader :todos

  def todos=(array)
    @todos = []
    array.each { |e| add(e) }
  end

  def copy_without_todos
    TodoList.new(title)
    # Copy all other attributes (trick: Marshal; otherwise, manually `dup` each one)
  end
end

# Use this class when displaying a subset of Todos in this list.
#
# An alternative to this class would require implementing all Enumerable
# methods so they return a copy of TodoList. One could implement those methods
# in a meta-programming way as follows:
# - Remove `include Enumerable`.
# - Implement `method_missing` method to handle all Enumerable methods.
#   - If the method is not in Enumerable: `super(symbol, *args)`
#   - If the method returns a collection that should be a TodoList copy,
#     - If no block was provided, chain enumerators where possible.
#     - If a block was provided, forward the block to the Enumerable method,
#       then `force` (`to_a`), then return a clone with the subset array.
#         - A complexity there would be determining the subset name.
#   - Forward all other methods to an Enumerable-including clone of `self`,
#     and return that invocation.
# That's still very complex, and there might be a library to enable such
# functionality if needed.
# ------
# Is it generally best to separate those concerns?
class TodoListSubset < TodoList
  def initialize(original_list, subset_title, todo_subset = [])
    super(original_list.title + " / #{subset_title}", todo_subset)

    @original_list = original_list
    @subset_title = subset_title
  end

  # What else could we do with this class?
  # - Include methods for comparing Original and Subset.
  # - Implement more advanced enumeration options that don't fit into the
  #   `TodoList` class.
  # - ...

  private

  attr_reader :original_list, :subset_title
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
  return true if expected_message.nil?

  e.message == expected_message
end

# ---- Adding to the list -----
puts '*** Add ***'

# add
list.add(todo1)                 # adds todo1 to end of list, returns list
list.add(todo2)                 # adds todo2 to end of list, returns list
p exception?(TypeError, 'Can only add Todo objects') { list.add(1) }

# <<
# same behavior as add
concatenated_list = (list << todo3)
p concatenated_list == list

# ---- Interrogating the list -----
puts '*** Interrogate ***'

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
puts '*** Retrieve ***'

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

puts '*** Enumerate ***'
each_return_val = list.each_with_index do |todo, idx|
  p(todo.to_s ==
    case idx
    when 0 then '[ ] Buy milk'
    when 1 then '[ ] Clean room'
    when 2 then '[ ] Go to gym'
    end)
end
p each_return_val.instance_of?(TodoList)

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

p(TodoListSubset.new(list, 'Sorted by Incomplete', list.sort).to_s == <<~LIST.strip
  ---- Today's Todos / Sorted by Incomplete ----
  [ ] Buy milk
  [ ] Go to gym
  [X] Clean room
LIST
 )

puts '*** Select ***'
selected = list.select(&:done?)
p selected.to_a == [todo2]

# Just for demo purposes--one would implement `select` to return
# `TodoListSubset` instead of an array as is done above.
# If we did the same for `reject`, we could use Enumerable#reject(&:done?) here
# instead:
select_subset = list.select_subset('Incomplete') { |todo| !todo.done? }
p select_subset.instance_of?(TodoListSubset)
p select_subset.to_a == [todo1, todo3]
p(select_subset.to_s == <<~LIST.strip
  ---- Today's Todos / Incomplete ----
  [ ] Buy milk
  [ ] Go to gym
LIST
 )

puts '*** Find ***'
p list.find_by_title('Go to gym') == todo3
p list.all_done.to_a == [todo2]
p list.all_not_done.to_a == [todo1, todo3]

puts '*** Mark ***'
# mark_undone_at
p exception?(ArgumentError) { list.mark_undone_at }
list.mark_undone_at(1)
p !todo2.done?
p exception?(IndexError) { list.mark_undone_at(100) }
p list.mark_done('Go to gym') == todo3
p todo3.done?
p list.mark_done('vjlas8d77j').nil?

# done!
list.done! # marks all items as done
p [todo1, todo2, todo3].all?(&:done?)
p list.done? == true

list.mark_all_undone
p !list.done?
list.mark_all_done
p list.done?

# ---- Deleting from the list -----
puts '*** Delete ***'

# remove_at
p exception?(ArgumentError) { list.remove_at }
removed_todo = list.remove_at(1) # removes and returns the 2nd item
p removed_todo == todo2
p exception?(IndexError) { list.remove_at(100) }

# shift
shifted_todo = list.shift # removes and returns the first item in list
p shifted_todo == todo1
p list.size == 1

# pop
popped_todo = list.pop # removes and returns the last item in list
p popped_todo == todo3
p list.empty?
