# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

# Create a rake task to automate tests - LS will probably teach this in the
# next lesson. If not, delve into these resources:
# https://gist.github.com/jcasimir/3c687bd5db16a73b4cf3
# http://docs.seattlerb.org/minitest/Minitest/TestTask.html
# https://github.com/ruby/rake
# https://backend.turing.edu/module1/lessons/project_etiquette#:~:text=with%20the%20flow.-,rakefiles,-Rake%20tasks%20come
# https://www.stuartellis.name/articles/rake/

require_relative 'todo_test'
require_relative 'todo_list_test'
require_relative 'todo_list_subset_test'
