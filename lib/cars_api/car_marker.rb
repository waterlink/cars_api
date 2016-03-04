require "cars_api"

module CarsApi
  # CarMarker represents a concrete carsharing proposition
  # with a walking distance
  CarMarker = Struct.new(:car, :distance)

  # CarMarkerFactory is a simple factory for CarMarkerValue
  module CarMarkerFactory
    def self.from(location, car, units)
      CarMarker.new(
        car,
        location.distance_to(car.location, units)
      )
    end
  end
end
