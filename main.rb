#!/usr/bin/env ruby

require 'optparse'

require './config'
require './lib/food_truck_parser'

options = {
  from_address: FROM_ADDRESS,
  time_limit: TIME_LIMIT,
  travel_mode: TRAVEL_MODE
}

OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options]"

  opts.on('-f', '--from [FROM ADDRESS]', String, "From address") do |from_address|
    options[:from_address] = from_address
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

  opts.on('-m', '--minutes-time-limit [TIME LIMIT]', Integer, "Maximum walking time (minutes)") do |time_limit|
    options[:time_limit] = time_limit * 60
  end

  opts.on('-s', '--seconds-time-limit [TIME LIMIT]', Integer, "Maximum walking time (seconds)") do |time_limit|
    options[:time_limit] = time_limit
  end

  travel_modes_list = FoodTruckParser::TravelTime::TRAVEL_MODES.join(', ')
  opts.on('-t', '--travel-mode [TRAVEL MODE]', String, FoodTruckParser::TravelTime::TRAVEL_MODES, "Travel mode (#{travel_modes_list})") do |travel_mode|
    if travel_mode
      options[:travel_mode] = travel_mode
    else
      puts opts
      exit
    end
  end
end.parse!

FoodTruckParser.configure do |config|
  config.distance_matrix_api_key = ENV['DISTANCE_MATRIX_API_KEY']
  config.travel_mode = options[:travel_mode]
end

spots = FoodTruckParser::BrigadeParser.new(options[:from_address]).retrieve_spots + FoodTruckParser::CamionParser.new(options[:from_address]).retrieve_spots
spots.select { |s| s.nearer_than(options[:time_limit]) }.each do |spot|
  puts "#{spot.restaurant} - #{spot.readable_date_interval} : #{spot.location} (#{spot.travel_duration_minutes} min)"
end
