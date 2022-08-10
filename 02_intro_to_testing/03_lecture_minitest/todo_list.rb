# frozen_string_literal: true

require 'forwardable'

require_relative 'todo'

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
    # Copy all other attributes...
    # Copy options:
    # - Use a Gem (no maintained Gems are available except one for Rails ActiveRecord cloning)
    # - Use trick: clone = Marshal.load(Marshal.dump(obj)) -- tricky and can be a security risk
    # - Manually set and `dup` each value here (requires maintenance when class changes)
  end
end
