require 'json'
require 'rest-client'

module FoodTruckParser

  class TravelTime
    DISTANCE_API_URL = 'https://maps.googleapis.com/maps/api/distancematrix/json'
    API_KEY = ENV['DISTANCE_MATRIX_API_KEY']

    class Error < RuntimeError; end
    class RequestDeniedError < Error; end
    class InvalidRequestError < Error; end
    class NotFoundError < Error; end
    class ZeroResultsError < Error; end

    def initialize(from:, to:, mode: 'walking')
      @from = from
      @to = to
      @mode = mode
    end

    def compute
      travel_time_response = JSON.parse(RestClient.get(DISTANCE_API_URL, { params: { origins: @from, destinations: @to, key: API_KEY, mode: @mode } }))

      fail RequestDeniedError, travel_time_response['error_message'] if travel_time_response['status'] == 'REQUEST_DENIED'
      fail InvalidRequestError, travel_time_response if travel_time_response['status'] == 'INVALID_REQUEST'
      fail InvalidRequestError, travel_time_response unless travel_time_response['status'] == 'OK'
      fail NotFoundError, 'Address not found' if travel_time_response['rows'].first['elements'].first['status'] == 'NOT_FOUND'
      fail ZeroResultsError, "Couldn't find a result for this trip" if travel_time_response['rows'].first['elements'].first['status'] == 'ZERO_RESULTS'

      {
        duration: travel_time_response['rows'].first['elements'].first['duration']['value']
      }
    end
  end

end
