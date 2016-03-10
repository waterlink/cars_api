require "cars_server"
require "cars_server/closest_cars_view"
require "cars_server/internal_error"
require "cars_api/get_closest_cars"
require "cars_util/simple_hash_builder"

module CarsServer
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
      raw_cars
        .when_ok { |cars| ClosestCarsView[cars] }
        .when_error { |message| InternalError[message] }
        .unwrap!
    end

    private

    attr_reader :interactor, :location, :limit, :units

    def result
      response.result
    end

    def raw_cars
      result.when_ok do |cars|
        Presenter.present_all(cars, units)
      end
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
      PRESENTER_SPEC = CarsUtil::SimpleHashBuilder
                       .load_spec("car_marker_presenter_spec")

      include CarsUtil::SimpleHashBuilder

      def initialize(car_marker, units)
        @car_marker = car_marker
        @units = units
      end

      def self.[](*args, &blk)
        new(*args, &blk)
      end

      def self.present_all(cars, units)
        cars
          .map { |car| new(car, units).present }
      end

      def present
        build_hash_with(PRESENTER_SPEC)
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
        "#{presented_distance} #{units}"
      end

      def presented_distance
        format("%.1f", car_marker.distance)
      end
    end
  end
end
