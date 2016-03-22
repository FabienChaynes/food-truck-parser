require 'minitest/autorun'
require_relative '../../test_helper'

class BrigadeParserTest < Minitest::Test
  def test_retrieve_spots_count
    VCR.use_cassette("FoodTruckParser/BrigadeParser") do
      restaurant_parser = FoodTruckParser::BrigadeParser.new('32 rue de trévise, 75009 Paris')

      assert_equal(12, restaurant_parser.retrieve_spots.count)
    end
  end

  def test_spot_restaurant
    VCR.use_cassette("FoodTruckParser/BrigadeParser") do
      restaurant_parser = FoodTruckParser::BrigadeParser.new('32 rue de trévise, 75009 Paris')

      assert_equal(['La Brigade'], restaurant_parser.retrieve_spots.map(&:restaurant).uniq)
    end
  end

  def test_spot
    VCR.use_cassette("FoodTruckParser/BrigadeParser") do
      restaurant_parser = FoodTruckParser::BrigadeParser.new('32 rue de trévise, 75009 Paris')
      spot = restaurant_parser.retrieve_spots.first

      assert_equal(DateTime.new(2016, 3, 24, 12)..DateTime.new(2016, 3, 24, 14), spot.date_interval)
      assert_equal('132, avenue de France,75013,Paris', spot.location)
      assert_equal(4749, spot.travel_duration)
    end
  end
end
