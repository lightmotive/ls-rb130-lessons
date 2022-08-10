# frozen_string_literal: true

require_relative 'todo_list'

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
