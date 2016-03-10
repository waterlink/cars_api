require "cars_api/in_memory"
require "cars_api/in_memory/car_store/closest_query"
require "cars_api/car_marker"

require "cars_util/equality"

module CarsApi
  module InMemory
    # job: InMemory::CarStore understands cars data.
    class CarStore
      extend CarsUtil::Equality

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

      def_equals [:data]

      protected

      attr_reader :data
    end
  end
end
