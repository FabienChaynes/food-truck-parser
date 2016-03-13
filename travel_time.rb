class TravelTime
  DISTANCE_API_URL = 'https://maps.googleapis.com/maps/api/distancematrix/json'
  API_KEY = ENV['DISTANCE_MATRIX_API_KEY']

  class RequestDeniedError < RuntimeError; end
  class InvalidRequestError < RuntimeError; end

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

    {
      duration: travel_time_response['rows'].first['elements'].first['duration']['value']
    }
  end
end
