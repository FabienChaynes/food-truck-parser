require 'minitest/autorun'
require_relative '../../test_helper'

class ConfigurationTest < Minitest::Test

  def test_configure
    assert_equal('', FoodTruckParser.configuration.distance_matrix_api_key)
    assert_equal('walking', FoodTruckParser.configuration.travel_mode)
    FoodTruckParser.configure do |config|
      config.distance_matrix_api_key = 'foo'
      config.travel_mode = 'bar'
    end

    assert_equal('foo', FoodTruckParser.configuration.distance_matrix_api_key)
    assert_equal('bar', FoodTruckParser.configuration.travel_mode)
    FoodTruckParser.reset!
  end

  def test_reset
    FoodTruckParser.configure do |config|
      config.distance_matrix_api_key = 'foo'
      config.travel_mode = 'bar'
    end
    assert_equal('foo', FoodTruckParser.configuration.distance_matrix_api_key)
    assert_equal('bar', FoodTruckParser.configuration.travel_mode)

    FoodTruckParser.reset!
    assert_equal('', FoodTruckParser.configuration.distance_matrix_api_key)
    assert_equal('walking', FoodTruckParser.configuration.travel_mode)
  end

end
