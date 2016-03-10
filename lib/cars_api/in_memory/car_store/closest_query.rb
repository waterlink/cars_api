require "cars_api/car_marker"

module CarsApi
  module InMemory
    class CarStore
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
            CarMarkerFactory.from(location, car, units)
          end
        end
      end
    end
  end
end
