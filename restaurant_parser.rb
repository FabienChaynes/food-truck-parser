class RestaurantParser

  attr_accessor :logger

  def initialize(address)
    @from_address = address
    @travel_time_responses = {}
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::WARN
  end
end
