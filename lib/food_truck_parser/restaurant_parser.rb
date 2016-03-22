require 'logger'

module FoodTruckParser

  class RestaurantParser

    attr_accessor :logger

    def initialize(address)
      @from_address = address
      @travel_time_responses = {}
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::WARN
    end

    def retrieve_spots
      fail NotImplementedError
    end
  end

end
