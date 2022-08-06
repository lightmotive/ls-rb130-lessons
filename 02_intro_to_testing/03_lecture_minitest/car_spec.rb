require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

require_relative 'car'

describe Car do
  describe 'when asked for wheels' do
    it 'has 4 wheels' do
      car = Car.new
      _(car.wheels).must_equal 4
    end

    it '(fails with 3 wheels)' do
      car = Car.new
      _(car.wheels).must_equal 3
    end
  end
end
