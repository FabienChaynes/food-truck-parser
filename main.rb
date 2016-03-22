#!/usr/bin/env ruby

require 'optparse'

require './config'
require './lib/food_truck_parser'

options = {
  from_address: FROM_ADDRESS,
  time_limit: TIME_LIMIT
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

  opts.on('-t', '--time-limit [TIME LIMIT]', Integer, "Maximum walking time (seconds)") do |time_limit|
    options[:time_limit] = time_limit
  end
end.parse!

spots = FoodTruckParser::BrigadeParser.new(options[:from_address]).retrieve_spots + FoodTruckParser::CamionParser.new(options[:from_address]).retrieve_spots
spots.select { |s| s.nearer_than(options[:time_limit]) }.each do |spot|
  puts "#{spot.restaurant} - #{spot.readable_date_interval} : #{spot.location} (#{spot.travel_duration_minutes} min)"
end
