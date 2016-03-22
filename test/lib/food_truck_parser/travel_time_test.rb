require 'minitest/autorun'
require_relative '../../test_helper'

class TravelTimeTest < Minitest::Test
  def test_compute
    VCR.use_cassette("FoodTruckParser/TravelTimeTest/test_compute") do
      assert_equal({ duration: 2933 }, FoodTruckParser::TravelTime.new(from: '5 Avenue Anatole France, 75007 Paris', to: '164 Rue de Rivoli, 75001 Paris').compute)
    end
  end

  def test_invalid_request
    VCR.use_cassette("FoodTruckParser/TravelTimeTest/test_invalid_request") do
      assert_raises FoodTruckParser::TravelTime::InvalidRequestError do
        FoodTruckParser::TravelTime.new(from: nil, to: '164 Rue de Rivoli, 75001 Paris').compute
      end
    end
  end

  def test_from_missing
    assert_raises ArgumentError do
      FoodTruckParser::TravelTime.new(to: '164 Rue de Rivoli, 75001 Paris')
    end
  end

  def test_to_missing
    assert_raises ArgumentError do
      FoodTruckParser::TravelTime.new(from: '164 Rue de Rivoli, 75001 Paris')
    end
  end

  def test_travel_mode
    FoodTruckParser.configure do |config|
      config.travel_mode = 'driving'
    end
    VCR.use_cassette("FoodTruckParser/TravelTimeTest/test_travel_mode") do
      assert_equal({ duration: 697 }, FoodTruckParser::TravelTime.new(from: '5 Avenue Anatole France, 75007 Paris', to: '164 Rue de Rivoli, 75001 Paris').compute)
    end
    FoodTruckParser.reset!
  end
end
