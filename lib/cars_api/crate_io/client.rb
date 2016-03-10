module CarsApi
  module CrateIO
    # Client encapsulates connection and different queries
    class Client
      def initialize(connection, queries)
        @connection = connection
        @queries = queries
      end

      def execute_get_closest(units, geoloc, limit)
        connection.execute(
          query_get_closest(units),
          [geoloc, limit]
        )
      end

      private

      attr_reader :connection, :queries

      def query_get_closest(units)
        queries.get_closest(units)
      end
    end
  end
end
