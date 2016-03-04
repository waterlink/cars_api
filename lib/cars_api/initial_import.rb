require "cars_api"

module CarsApi
  module InitialImport
    # Request represents InitialImport use case input data
    Request = Struct.new(:data_source)

    # Response represents InitialImport use case output data
    Response = Struct.new(:ok, :error)

    # ResponseFactory understands construction of Response
    module ResponseFactory
      def self.from_result(result)
        from_error(from_ok(result)).unwrap!
      end

      def self.from_ok(ok)
        ok.when_ok { Response[true, nil] }
      end

      def self.from_error(error)
        error.when_error { |message| Response[false, message] }
      end
    end

    # Describes protocol for DataSource required by InitialImport
    class DataSourceProtocol
      # @!group Required Methods

      # @!method each
      #   @yield [raw_car] Block to yield to with each car
      #     data
      #   @yieldparam raw_car [Hash] Car data in the form of hash

      # @!endgroup
    end

    # Describes protocol for CarStore required by InitialImport
    class CarStoreProtocol
      # @!group Required Methods

      # @!method save(car)
      #   Saves a car to a car store
      #   @param car [Car] Car to save
      #   @return [Result::ResultProtocol] Result or an error message

      # @!method clear
      #   Clears data from the car store. Use with caution
      #   @return [Result::ResultProtocol] Result or an error message

      # @!endgroup
    end
  end
end
