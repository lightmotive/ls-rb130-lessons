require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

require_relative 'car'

class CarTest < MiniTest::Test
  def test_wheels
    car = Car.new
    assert_equal(4, car.wheels)
  end

  def test_fail_wheels
    skip('To be implemented...')
    car = Car.new
    assert_equal(3, car.wheels)
  end
end
