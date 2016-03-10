require "cars_api"

module CarsApi
  # CarBuilder undestands stored car format
  class CarBuilder
    def initialize(raw_car)
      @raw_car = raw_car
    end

    def self.build(raw_car)
      new(raw_car).build_car
    end

    def build_car
      Car[description, Location[latitude, longitude]]
    end

    private

    attr_reader :raw_car

    def description
      raw_car["description"]
    end

    def latitude
      location["latitude"]
    end

    def longitude
      location["longitude"]
    end

    def location
      @_location ||= raw_car["location"]
    end
  end
end
