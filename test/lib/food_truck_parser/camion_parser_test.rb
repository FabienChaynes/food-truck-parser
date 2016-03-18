require 'minitest/autorun'
require_relative '../../test_helper'

class CamionParserTest < Minitest::Test
  def test_retrieve_spots_count
    VCR.use_cassette("FoodTruckParser/CamionParser") do
      restaurant_parser = FoodTruckParser::CamionParser.new('32 rue de trévise, 75009 Paris')

      assert_equal(18, restaurant_parser.retrieve_spots.count)
    end
  end

  def test_spot_restaurant
    VCR.use_cassette("FoodTruckParser/CamionParser") do
      restaurant_parser = FoodTruckParser::CamionParser.new('32 rue de trévise, 75009 Paris')

      assert_equal(['Le Camion qui Fume'], restaurant_parser.retrieve_spots.map(&:restaurant).uniq)
    end
  end

  def test_spot
    VCR.use_cassette("FoodTruckParser/CamionParser") do
      restaurant_parser = FoodTruckParser::CamionParser.new('32 rue de trévise, 75009 Paris')
      spot = restaurant_parser.retrieve_spots.first

      assert_equal(DateTime.new(2016, 3, 18, 12)..DateTime.new(2016, 3, 18, 14, 30), spot.date_interval)
      assert_equal('132 avenue de France, Paris', spot.location)
      assert_equal(4749, spot.travel_duration)
    end
  end

  def test_exclude_restaurant_address
    VCR.use_cassette("FoodTruckParser/CamionParser") do
      restaurant_parser = FoodTruckParser::CamionParser.new('32 rue de trévise, 75009 Paris')

      assert_equal(false, restaurant_parser.retrieve_spots.map(&:location).uniq.include?('168 Rue Montmartre, Paris'))
    end
  end
end
