module FoodTruckParser

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset!
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :distance_matrix_api_key, :travel_mode

    def initialize
      @distance_matrix_api_key = ''
      @travel_mode = 'walking'
    end
  end

end
