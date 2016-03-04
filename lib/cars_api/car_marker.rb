require "cars_api"

module CarsApi
  # CarMarker represents a concrete carsharing proposition
  # with a walking distance
  CarMarker = Struct.new(:car, :distance) do
    def self.from(location, car, units)
      new(
        car,
        location.distance_to(car.location, units)
      )
    end
  end
end
