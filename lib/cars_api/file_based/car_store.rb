require "json"

require "cars_api/file_based"
require "cars_api/result"
require "cars_api/car_builder"
require "cars_api/in_memory/car_store/closest_query"

require "cars_util/simple_hash_builder"
require "cars_util/equality"

module CarsApi
  module FileBased
    # CarStore understands how to fetch and store cars in a file
    class CarStore
      extend CarsUtil::Equality

      def initialize(path)
        @path = path
        clear unless File.exist?(path)
        reload
      end

      def get_closest(location, limit, units = :kms)
        reload
        InMemory::CarStore::ClosestQuery
          .new(cars, location, units)
          .call(limit)
      end

      def save(car)
        data << CarSerializer.serialize(car)
        save_data
      end

      def clear
        @data = []
        save_data
      end

      def_equals [:data]

      protected

      attr_reader :data

      private

      attr_reader :path

      def save_data
        File.open(path, "w") do |file|
          file.write(data.to_json)
        end
        reload
        Result.ok(nil)
      end

      def reload
        @data = JSON.parse(File.read(path))
      end

      def cars
        data.map { |raw| CarBuilder.build(raw) }
      end

      # CarSerializer understands in-memory car structure
      class CarSerializer
        LOCATION_SPEC = CarsUtil::SimpleHashBuilder
                        .load_spec("car_serializer_location_spec")

        CAR_SPEC = CarsUtil::SimpleHashBuilder
                   .load_spec("car_serializer_spec")

        include CarsUtil::SimpleHashBuilder

        def initialize(car)
          @car = car
        end

        def self.serialize(car)
          new(car).serialize
        end

        def serialize
          build_hash_with(CAR_SPEC)
        end

        private

        attr_reader :car

        def description
          car.description
        end

        def location
          build_hash_with(LOCATION_SPEC)
        end

        def latitude
          car_location.latitude
        end

        def longitude
          car_location.longitude
        end

        def car_location
          @_car_location ||= car.location
        end
      end
    end
  end
end
