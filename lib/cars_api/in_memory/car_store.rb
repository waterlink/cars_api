require "cars_api/in_memory"
require "cars_api/car_marker"

module CarsApi
  module InMemory
    # job: InMemory::CarStore understands cars data.
    class CarStore
      def initialize(data = [])
        @data = data
      end

      def get_closest(location, limit, units = :kms)
        ClosestQuery
          .new(data, location, units)
          .call(limit)
      end

      private

      attr_reader :data

      # ClosestQuery represents a get_closest query
      class ClosestQuery
        def initialize(data, location, units)
          @data = data
          @location = location
          @units = units
        end

        def call(limit)
          car_markers
            .sort_by(&:distance)
            .first(limit)
        end

        private

        attr_reader :data, :location, :units

        def car_markers
          data.map do |car|
            CarMarker.from(location, car, units)
          end
        end
      end
    end
  end
end
