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
        Response[
          Call.new(request, car_store).closest
        ]
      end

      private

      attr_reader :car_store

      # Call represents one specific interactor action
      class Call
        def initialize(request, car_store)
          @location = request.location
          @limit = request.n
          @units = request.units

          @car_store = car_store
        end

        def closest
          car_store.get_closest(location, limit, units)
        end

        private

        attr_reader :location, :limit, :car_store

        def units
          @units || :kms
        end
      end
    end
  end
end
