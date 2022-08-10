# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

require_relative 'todo_test'
require_relative 'todo_list_test'
require_relative 'todo_list_subset_test'
