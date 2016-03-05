require "cars_api/initial_import"
require "cars_api/result"
require "cars_api/location"

module CarsApi
  module InitialImport
    # job: InitialImport::Interactor represents an
    # 'InitialImport' usecase business logic.
    class Interactor
      def initialize(car_store)
        @car_store = car_store
      end

      def call(request)
        ResponseFactory.from_result(
          Call.new(request, car_store).import
        )
      end

      private

      attr_reader :car_store

      # Call represents concrete instance of usecase
      # application
      class Call
        OK = Result.ok(nil)

        def initialize(request, car_store)
          @data_source = request.data_source
          @car_store = car_store
        end

        def import
          clear
            .when_ok { store }
            .join
        end

        private

        attr_reader :data_source, :car_store

        def clear
          car_store.clear
        end

        def save(result, car)
          result
            .when_ok { car_store.save(car) }
            .join
        end

        def store
          mass_builder.reduce(OK) do |result, car|
            save(result, car)
          end
        end

        def mass_builder
          MassCarBuilder.new(data_source)
        end
      end

      # MassCarBuilder understands how to build multiple
      # cars one-by-one from data source
      class MassCarBuilder
        def initialize(data_source)
          @data_source = data_source
        end

        def reduce(acc)
          data_source.each do |data|
            acc = yield(
              acc,
              CarBuilder.new(data).build_car
            )
          end

          acc
        end

        private

        attr_reader :data_source
      end

      # CarBuilder understands structure of raw data for
      # cars
      class CarBuilder
        def initialize(data)
          @data = data
        end

        def build_car
          Car[description, location]
        end

        private

        attr_reader :data

        def description
          data[:description]
        end

        def location
          Location[latitude, longitude]
        end

        def latitude
          data[:latitude]
        end

        def longitude
          data[:longitude]
        end
      end
    end
  end
end
