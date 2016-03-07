require "cars_api/in_memory"

module CarsApi
  module InMemory
    # DataSource is an implementation of InitialImport::DataSourceProtocol
    class DataSource
      def initialize(data = [])
        @data = data
      end

      def each(&block)
        data.each(&block)
      end

      private

      attr_reader :data
    end
  end
end
