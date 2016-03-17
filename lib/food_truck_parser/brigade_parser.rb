require 'open-uri'
require 'nokogiri'

require_relative './restaurant_parser'
require_relative './spot'
require_relative './travel_time'

module FoodTruckParser

  class BrigadeParser < RestaurantParser
    TRACKING_URL = 'http://agenda.la-brigade.fr/droite.html'
    GOOGLE_MAPS_URL = 'https://www.google.com/maps/preview?f=q&hl=fr&q='
    RESTAURANT_NAME = 'La Brigade'

    def body
      @body ||= open(TRACKING_URL)
    end

    def retrieve_spots
      spots = []
      begin
        doc = Nokogiri::HTML(body)
        date_infos = fetch_date_infos(doc)
        date_infos.each do |date_info|
          date_interval = parse_time(fetch_date(date_info), fetch_time(date_info))
          location = fetch_location(date_info)
          begin
            travel_time_response = @travel_time_responses[location] ||= TravelTime.new(from: @from_address, to: location).compute
            spots << Spot.new(date_interval: date_interval, location: location, travel_duration: travel_time_response[:duration], restaurant: RESTAURANT_NAME)
          rescue FoodTruckParser::TravelTime::Error => e
            @logger.warn "Couldn't find travel time for #{@from_address} -> #{location} (#{e.class} : #{e.message})"
          end
        end
      rescue OpenURI::HTTPError => e
        @logger.warn "Error during #{RESTAURANT_NAME} parsing : #{e.message}"
      end
      spots
    end

    private

    def fetch_date(date_info)
      date_info.css('h3').text
    end

    def fetch_date_infos(doc)
      doc.css('.dateagenda')
    end

    def fetch_location(date_info)
      URI.unescape(date_info.css('a').attr('href').text.sub(GOOGLE_MAPS_URL, ''))
    end

    def fetch_time(date_info)
      date_info.css('.infosjoursuivant div div')[1].text
    end

    def parse_time(date_str, time_str)
      time = time_str.gsub(/MIDI |SOIR /, '').strip
      time_start, time_end = time.split('-')
      date_start = DateTime.parse("#{date_str} #{time_start}")
      date_end = DateTime.parse("#{date_str} #{time_end}")
      date_start..date_end
    end
  end

end
