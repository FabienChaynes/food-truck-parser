require './config'
require './lib/food_truck_parser'

spots = FoodTruckParser::BrigadeParser.new(FROM_ADDRESS).retrieve_spots + FoodTruckParser::CamionParser.new(FROM_ADDRESS).retrieve_spots
spots.select { |s| s.nearer_than(TIME_LIMIT) }.each do |spot|
  puts "#{spot.restaurant} - #{spot.readable_date_interval} : #{spot.location} (#{spot.travel_duration_minutes} min)"
end
