# frozen_string_literal: true

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
