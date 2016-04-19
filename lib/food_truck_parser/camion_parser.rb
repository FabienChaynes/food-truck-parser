require 'cgi'
require 'nokogiri'
require 'open-uri'

require_relative './restaurant_parser'
require_relative './spot'
require_relative './travel_time'

module FoodTruckParser

  class CamionParser < RestaurantParser
    TRACKING_URL = 'http://click-eat.fr/trackthetruck/camionquifume'
    GOOGLE_MAPS_URL = 'http://www.google.fr/maps?q='
    RESTAURANT_ADDRESSES = ['168 Rue Montmartre, Paris']
    RESTAURANT_NAME = 'Le Camion qui Fume'

    def retrieve_spots
      spots = []

      begin
        doc = Nokogiri::HTML(body)
        date_infos = fetch_date_infos(doc)
        date_infos.each do |date_info|
          date = fetch_date(date_info)
          periods = fetch_periods(date_info)

          periods.each do |period|
            location = fetch_location(period)

            unless RESTAURANT_ADDRESSES.include?(location)
              time = fetch_time(period)
              date_interval = parse_time(date, time)
              begin
                travel_time_response = @travel_time_responses[location] ||= TravelTime.new(from: @from_address, to: location).compute
                spots << Spot.new(date_interval: date_interval, location: location, travel_duration: travel_time_response[:duration], restaurant: RESTAURANT_NAME)
              rescue FoodTruckParser::TravelTime::Error => e
                @logger.warn "Couldn't find travel time for #{@from_address} -> #{location} (#{e.class} : #{e.message})"
              end
            end
          end
        end
      rescue OpenURI::HTTPError => e
        @logger.warn "Error during #{RESTAURANT_NAME} parsing : #{e.message}"
      end
      spots
    end

    private

    def body
      @body ||= open(TRACKING_URL)
    end

    def fetch_date(date_info)
      date_info.css('.timeline-title').text
    end

    def fetch_date_infos(doc)
      doc.css('.timeline-panel')
    end

    def fetch_location(period)
      CGI::unescape(period.css('a').attr('href').text.sub(GOOGLE_MAPS_URL, ''))
    end

    def fetch_periods(date_info)
      date_info.css('p')
    end

    def fetch_time(period)
      period.to_html.split('<br>').first[5..-1].strip
    end

    def parse_time(date_str, time_str)
      date_str = translate_date(date_str)
      time_start = time_str.split('-').first.strip
      time_end = time_str.split('-').last.gsub('*', '').strip
      date_start = DateTime.parse("#{date_str} #{time_start}")
      date_end = DateTime.parse("#{date_str} #{time_end}")
      date_start..date_end
    end
  end

end
