module FoodTruckParser

  class Spot
    attr_reader :date_interval, :location, :travel_duration, :restaurant

    def initialize(date_interval: '', location: '', travel_duration: nil, restaurant: '')
      @date_interval = date_interval
      @location = location
      @travel_duration = travel_duration.to_i
      @restaurant = restaurant
    end

    def nearer_than(seconds)
      travel_duration <= seconds
    end

    def travel_duration_minutes
      travel_duration / 60
    end

    def readable_date_interval
      "#{date_format(date_interval.first)} - #{date_interval.last.strftime('%k:%M')}"
    end

    private

    def date_format(date)
      date.strftime('%a, %-d/%m/%Y %k:%M')
    end
  end

end
