require "cars_api"

module CarsApi
  module InitialImport
    # Request represents InitialImport use case input data
    Request = Struct.new(:data_source)

    # Response represents InitialImport use case output data
    Response = Struct.new(:ok, :error)

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
      #   @return [String] Error message, nil if succeeded

      # @!method clear
      #   Clears data from the car store. Use with caution
      #   @return [String] Error message, nil if succeeded

      # @!endgroup
    end
  end
end
