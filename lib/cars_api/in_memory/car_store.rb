require "cars_api/in_memory"
require "cars_api/in_memory/car_store/closest_query"
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

      def clear
        @data = []
        Result.ok(nil)
      end

      def save(car)
        @data << car
        Result.ok(nil)
      end

      # suppress :reek:FeatureEnvy
      def ==(other)
        return false unless other.is_a?(CarStore)
        data == other.data
      end

      protected

      attr_reader :data
    end
  end
end
