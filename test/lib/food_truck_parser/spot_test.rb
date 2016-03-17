require 'minitest/autorun'
require_relative '../../test_helper'

class SpotTest < Minitest::Test
  def test_init
    spot = FoodTruckParser::Spot.new

    assert_equal('', spot.date_interval)
    assert_equal('', spot.location)
    assert_equal(0, spot.travel_duration)
    assert_equal('', spot.restaurant)
  end

  def test_nearer_than_true
    spot = FoodTruckParser::Spot.new(travel_duration: 600)

    assert_equal(true, spot.nearer_than(600))
    assert_equal(true, spot.nearer_than(700))
  end

  def test_nearer_than_false
    spot = FoodTruckParser::Spot.new(travel_duration: 600)

    assert_equal(false, spot.nearer_than(599))
  end

  def test_travel_duration_minutes
    spot = FoodTruckParser::Spot.new(travel_duration: 600)

    assert_equal(10, spot.travel_duration_minutes)
  end

  def test_travel_duration_minutes_floored
    spot = FoodTruckParser::Spot.new(travel_duration: 620)

    assert_equal(10, spot.travel_duration_minutes)
  end

  def test_readable_date_interval
    spot = FoodTruckParser::Spot.new(date_interval: DateTime.new(2015, 1, 20, 12)..DateTime.new(2015, 1, 20, 14))

    assert_equal("Tue, 20/01/2015 12:00 - 14:00", spot.readable_date_interval)
  end

end
