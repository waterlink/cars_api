require "cars_api/location"
require "cars_api/result"

module CarsServer
  # LocationParser understands location query params format
  class LocationParser
    INVALID_LONGITUDE =
      "Unable to parse location.longitude query parameter".freeze

    INVALID_LATITUDE =
      "Unable to parse location.latitude query parameter".freeze

    MISSING_LOCATION =
      "Query parameter location is required".freeze

    def initialize(params, delimiter = ",")
      @params = params
      @delimiter = delimiter
    end

    def location
      latitude
        .when_ok { |lat| PartialLocation.location(lat, longitude) }
        .join
    end

    private

    attr_reader :params, :delimiter

    def latitude
      parse_value(0, INVALID_LATITUDE)
    end

    def longitude
      parse_value(1, INVALID_LONGITUDE)
    end

    def parse_value(index, error)
      when_location_tuple do |tuple|
        CarsApi::Result
          .from(tuple[index]) { error }
          .when_ok(&:to_f)
      end
    end

    def when_location_tuple(&block)
      location_tuple.when_ok(&block).join
    end

    def location_tuple
      @_location_tuple ||= build_location_tuple
    end

    def build_location_tuple
      raw_location.when_ok(&split_by_delimiter)
    end

    def raw_location
      CarsApi::Result
        .from(params[:location]) { MISSING_LOCATION }
    end

    def _split_by_delimiter(str)
      str.split(delimiter)
    end

    def split_by_delimiter
      method(:_split_by_delimiter)
    end

    # PartialLocation understands step-by-step process of building a Location
    class PartialLocation
      def initialize(lat)
        @lat = lat
      end

      def self.location(lat, longitude)
        new(lat).location(longitude)
      end

      def location(longitude)
        longitude.when_ok do |long|
          CarsApi::Location[lat, long]
        end
      end

      private

      attr_reader :lat
    end
  end
end
