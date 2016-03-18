require 'minitest/autorun'
require_relative '../../test_helper'

class RestaurantParserTest < Minitest::Test
  def test_retrieve_spots_not_implemented
    restaurant_parser = FoodTruckParser::RestaurantParser.new('32 rue de trévise, 75009 Paris')

    assert_raises NotImplementedError do
      restaurant_parser.retrieve_spots
    end
  end
end
