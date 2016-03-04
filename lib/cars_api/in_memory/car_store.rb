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
        data.map do |car|
          CarMarker.from(location, car, units)
        end.sort_by(&:distance).first(limit)
      end

      private

      attr_reader :data
    end
  end
end
