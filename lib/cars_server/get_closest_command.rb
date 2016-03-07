require "cars_server"
require "cars_api/get_closest_cars"

module CarsServer
  # ClosestCarsViewStruct is a value object for ClosestCars view
  ClosestCarsViewStruct = Struct.new(:cars)

  # ClosestCarsView is an API view for GetClosestCars use case
  class ClosestCarsView < ClosestCarsViewStruct
  end

  # GetClosestCommand is a command to work with GetClosestCars interactor
  class GetClosestCommand
    UNITS = {
      "kms" => :kms,
      "miles" => :miles
    }.freeze
    DEFAULT_UNITS = :kms

    def initialize(interactor, location, limit, units)
      @interactor = interactor
      @location = location
      @limit = limit
      @units = UNITS.fetch(units, DEFAULT_UNITS)
    end

    def call
      ClosestCarsView[raw_cars]
    end

    private

    attr_reader :interactor, :location, :limit, :units

    def cars
      response.cars
    end

    def presenters
      cars.map { |car_marker| Presenter[car_marker, units] }
    end

    def raw_cars
      presenters.map(&:present)
    end

    def response
      interactor.call(request)
    end

    def request
      CarsApi::GetClosestCars::Request[
        location, limit, units
      ]
    end

    # Presenter understands rendering process of car markers
    class Presenter
      def initialize(car_marker, units)
        @car_marker = car_marker
        @units = units
      end

      def self.[](*args, &blk)
        new(*args, &blk)
      end

      def present
        {
          description: description,
          latitude: latitude,
          longitude: longitude,
          distance: distance
        }
      end

      private

      attr_reader :car_marker, :units

      def car
        @_car ||= car_marker.car
      end

      def description
        car.description
      end

      def location
        @_location ||= car.location
      end

      def latitude
        location.latitude
      end

      def longitude
        location.longitude
      end

      def distance
        "#{car_marker.distance} #{units}"
      end
    end
  end
end
