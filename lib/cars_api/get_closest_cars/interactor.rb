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
          car_store.get_closest(
            request.location,
            request.n,
            units(request.units)
          )
        ]
      end

      private

      attr_reader :car_store

      def units(value)
        return :kms unless value
        value
      end
    end
  end
end
