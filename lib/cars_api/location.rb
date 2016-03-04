require "cars_api"
require "geokit"

module CarsApi
  # Location represents a position on the map
  Location = Struct.new(:latitude, :longitude) do
    def distance_to(other, units)
      GEOCALC.distance_between(
        self.to_a,
        other.to_a,
        units: units
      )
    end

    # :nodoc:
    class GeoCalc
      include Geokit::Mappable::ClassMethods
    end

    GEOCALC = GeoCalc.new
  end
end
