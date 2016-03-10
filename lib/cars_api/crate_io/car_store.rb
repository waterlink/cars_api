require "securerandom"

require "crate_ruby"

require "cars_api/crate_io"
require "cars_api/crate_io/queries"
require "cars_api/crate_io/closest_query"
require "cars_api/crate_io/client"
require "cars_api/car_marker"
require "cars_api/location"
require "cars_util/equality"

module CarsApi
  module CrateIO
    # CarStore implements CarStore protocols with crate.io as a backend
    class CarStore
      extend CarsUtil::Equality

      def initialize(table, connection: CrateRuby::Client.new)
        @table = table
        @connection = connection
        @immediate_refresh = false
        init_table
      end

      def get_closest(location, limit, units = :kms)
        ClosestQuery.new(
          CrateIO.geoloc_from(location),
          limit,
          units,
          client
        ).fetch_cars
      end

      def save(car)
        Result.do do
          connection.execute(queries.save, CarToRowMapper.from(car))
          refresh
        end
      end

      def clear
        Result.do do
          connection.execute(queries.clear)
          refresh
        end
      end

      def_equals [:all]

      def _with_immediate_refresh
        @immediate_refresh = true
        self
      end

      protected

      def all
        refresh
        connection
          .execute(queries.all)
          .sort
      end

      private

      attr_reader :table, :connection, :immediate_refresh

      def init_table
        connection.execute(queries.init_table)
      end

      def refresh
        return unless immediate_refresh
        connection.refresh_table(table)
        nil
      end

      def queries
        @_queries ||= Queries.new(table)
      end

      def client
        Client.new(connection, queries)
      end

      # CarToRowMapper understands conversion rules from Car to crate.io's row
      class CarToRowMapper
        def initialize(car)
          @car = car
        end

        def self.from(car)
          new(car).row
        end

        def row
          [SecureRandom.uuid, description, geoloc]
        end

        private

        attr_reader :car

        def description
          car.description
        end

        def geoloc
          CrateIO.geoloc_from(location)
        end

        def location
          car.location
        end
      end
    end
  end
end
