require "cars_api/get_closest_cars"

module CarsApi
  module GetClosestCars
    # job: GetClosestCars::Interactor represents a 'GetClosestCars' usecase
    # business logic.
    class Interactor
      def initialize(car_store)
        @car_store = car_store
      end

      def call(request)
        Response[Call.new(request, car_store).closest]
      end

      private

      attr_reader :car_store

      # Call represents one specific interactor action
      class Call
        def initialize(request, car_store)
          @location = request.location
          @limit = request.n
          @units = self.class.units_from(request.units)

          @car_store = car_store
        end

        def self.units_from(value)
          return :kms unless value
          value
        end

        def closest
          car_store.get_closest(location, limit, units)
        end

        private

        attr_reader :location, :limit, :units, :car_store
      end
    end
  end
end
