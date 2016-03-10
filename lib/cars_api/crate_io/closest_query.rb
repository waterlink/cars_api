require "cars_api/crate_io"
require "cars_api/car_marker"
require "cars_api/location"

module CarsApi
  module CrateIO
    # ClosestQuery understands structure of GetClosestCars query
    class ClosestQuery
      def initialize(geoloc, limit, units, client)
        @geoloc = geoloc
        @limit = limit
        @units = units
        @client = client
      end

      def fetch_cars
        Result.do do
          fetch_cars!
        end
      end

      private

      attr_reader :geoloc, :limit, :units, :client

      def fetch_cars!
        return [] if limit == 0

        execute_query.map do |row|
          CarMarkerMapper.from_row(row)
        end
      end

      def execute_query
        client.execute_get_closest(units, geoloc, limit)
      end

      # CarMarkerMapper knows structure of different things that can be mapped
      # to CarMarker
      class CarMarkerMapper
        def initialize(_id, description, geoloc, distance)
          @description = description
          @geoloc = geoloc
          @distance = distance
        end

        def self.from_row(row)
          new(*row).marker
        end

        def marker
          CarMarker[car, distance]
        end

        private

        attr_reader :description, :geoloc, :distance

        def car
          Car[description, location]
        end

        def location
          longitude, latitude = geoloc
          Location[latitude, longitude]
        end
      end
    end
  end
end
