require "cars_api"

module CarsApi
  module GetClosestCars
    Request = Struct.new(:location, :n, :units)
    Response = Struct.new(:cars)

    # Describes protocol for CarStore required by GetClosestCars
    class CarStoreProtocol
      # @!group Required Methods

      # @!method get_closest(location, limit)
      #   @param location [Location] Location to search for closest cars from
      #   @param limit [Integer] Amount of cars to return
      #   @param optional units [Symbol] Units of distance (:miles or :kms)
      #     (default :kms)
      #   @return [Array<CarMarker>] Closest cars

      # @!endgroup
    end
  end
end
