require "cars_api/in_memory"
require "geokit"

module CarsApi
  module InMemory
    class CarStore
      def initialize(data = [])
        @data = data
      end

      def get_closest(location, limit, units = :kms)
        data
          .map { |x| car_marker(location, x, units) }
          .sort_by(&:distance)
          .first(limit)
      end

      private

      attr_reader :data

      def distance_between(a, b, units)
        GEOCALC.distance_between(
          a.to_a,
          b.to_a,
          units: units,
        )
      end

      def car_marker(location, car, units)
        CarMarker[
          car,
          distance_between(
            location,
            car.location,
            units,
          ),
        ]
      end

      class GeoCalc
        include Geokit::Mappable::ClassMethods
      end

      GEOCALC = GeoCalc.new
    end
  end
end
