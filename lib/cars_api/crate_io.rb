require "cars_api/location"

module CarsApi
  # CrateIO integrates the application with crate.io
  module CrateIO
    def self.geoloc_from(location)
      location.to_a.reverse
    end
  end
end
