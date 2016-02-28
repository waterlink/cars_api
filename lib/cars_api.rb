require "cars_api/version"

module CarsApi
  Location = Struct.new(:latitude, :longitude)
  Car = Struct.new(:description, :location)
  CarMarker = Struct.new(:car, :distance)
end
