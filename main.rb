require './brigade_parser'
require './camion_parser'
require './config'
require './spot'

spots = BrigadeParser.new(FROM_ADDRESS).retrieve_spots + CamionParser.new(FROM_ADDRESS).retrieve_spots
spots.select { |s| s.nearer_than(TIME_LIMIT) }.each do |spot|
  puts "#{spot.restaurant} - #{spot.readable_date_interval} : #{spot.location} (#{spot.travel_duration_minutes} min)"
end
