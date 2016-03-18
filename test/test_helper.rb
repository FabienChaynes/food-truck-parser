require 'minitest/autorun'
require 'vcr'
require 'webmock'

require File.expand_path('../../lib/food_truck_parser', __FILE__)

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock
end
