require "cars_api"
require "geokit"

module CarsApi
  # LocationValue represents a position on the map
  LocationValue = Struct.new(:latitude, :longitude)

  # Location represents a position on the map with required behavior
  class Location < LocationValue
    def distance_to(other, units)
      GEOCALC.distance_between(
        to_a,
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
