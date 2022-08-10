# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

# Create a rake task to automate tests

require './test/todo_test'
require './test/todo_list_test'
require './test/todo_list_subset_test'
