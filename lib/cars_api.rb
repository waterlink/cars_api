require "cars_api/version"

module CarsApi
  # Car represents a concrete carsharing proposition
  Car = Struct.new(:description, :location)
end
