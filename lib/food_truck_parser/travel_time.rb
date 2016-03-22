require 'json'
require 'net/http'

require_relative './configuration'

module FoodTruckParser

  class TravelTime
    DISTANCE_API_URL = 'https://maps.googleapis.com/maps/api/distancematrix/json'
    TRAVEL_MODES = ['bicycling', 'driving', 'transit', 'walking']

    class Error < RuntimeError; end
    class RequestError < Error; end
    class RequestDeniedError < Error; end
    class InvalidRequestError < Error; end
    class NotFoundError < Error; end
    class ZeroResultsError < Error; end

    def initialize(from:, to:, mode: travel_mode)
      @from = from
      @to = to
      @mode = mode
    end

    def compute
      travel_time_response = JSON.parse(call_api(origins: @from, destinations: @to, key: api_key, mode: @mode))

      fail RequestDeniedError, travel_time_response['error_message'] if travel_time_response['status'] == 'REQUEST_DENIED'
      fail InvalidRequestError, travel_time_response if travel_time_response['status'] == 'INVALID_REQUEST'
      fail InvalidRequestError, travel_time_response unless travel_time_response['status'] == 'OK'
      fail NotFoundError, 'Address not found' if travel_time_response['rows'].first['elements'].first['status'] == 'NOT_FOUND'
      fail ZeroResultsError, "Couldn't find a result for this trip" if travel_time_response['rows'].first['elements'].first['status'] == 'ZERO_RESULTS'

      {
        duration: travel_time_response['rows'].first['elements'].first['duration']['value']
      }
    end

    private

    def api_key
      FoodTruckParser.configuration.distance_matrix_api_key
    end

    def call_api(params)
      uri = URI(DISTANCE_API_URL)
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      fail RequestError, "#{res.code} : #{res.message} (#{res.uri})" unless res.is_a?(Net::HTTPSuccess)
      res.body
    end

    def travel_mode
      FoodTruckParser.configuration.travel_mode
    end
  end

end
