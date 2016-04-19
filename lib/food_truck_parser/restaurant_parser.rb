require 'logger'

module FoodTruckParser

  class RestaurantParser

    MONTHS_TRANSLATION = {
      'janvier' => 'january', 'fevrier' => 'february', 'mars' => 'march',
      'avril' => 'april', 'mai' => 'may', 'juin' => 'june',
      'juillet' => 'july', 'aout' => 'august', 'septembre' => 'september',
      'octobre' => 'october', 'novembre' => 'november', 'decembre' => 'december',
    }

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

    protected

    def translate_date(str)
      str = str.downcase
      MONTHS_TRANSLATION.each { |fr, en| str.gsub!(fr, en) }
      str
    end
  end

end
