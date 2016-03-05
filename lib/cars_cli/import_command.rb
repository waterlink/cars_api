require "cars_api/initial_import"
require "cars_cli"
require "cars_cli/success_view"
require "cars_cli/failure_view"
require "json"

module CarsCli
  # ImportCommand understands import process requirements
  class ImportCommand
    def initialize(interactor, path)
      @interactor = interactor
      @path = path
    end

    def call
      view_class[response]
    end

    private

    attr_reader :interactor, :path

    def view_class
      return FailureView unless response.ok
      SuccessView
    end

    def response
      @_response ||= interactor.call(request)
    end

    def data_source
      FileDataSource.new(path)
    end

    def request
      CarsApi::InitialImport::Request[data_source]
    end

    # FieldReader understands raw data -> structured data transformation for a
    # specific field
    class FieldReader
      def initialize(key, &blk)
        @key = key
        @strategy = blk
      end

      def self.[](*args, &blk)
        new(*args, &blk)
      end

      def self.from(key, strategy)
        new(key, &strategy)
      end

      def read(src)
        strategy.call(src[key])
      end

      private

      attr_reader :key, :strategy
    end

    # CarDataReader is a collection of raw data transformations to read raw car
    # data as structured data
    class CarDataReader
      READERS = {
        description: FieldReader["description", &:to_s],
        latitude: FieldReader["latitude", &:to_f],
        longitude: FieldReader["longitude", &:to_f]
      }.freeze

      def initialize(data)
        @data = data
      end

      def self.read(data)
        new(data).read
      end

      def read
        READERS.each_with_object({}) do |(key, reader), hash|
          hash[key] = reader.read(data)
        end
      end

      private

      attr_reader :data
    end

    # FileDataSource understands the way DataSource is stored on disk
    class FileDataSource
      def initialize(path)
        @path = path
      end

      def each
        locations.each do |hash|
          yield(CarDataReader.read(hash))
        end
      end

      private

      attr_reader :path

      def locations
        data.fetch("locations", [])
      end

      def data
        @_data ||= JSON.load(raw)
      end

      def raw
        File.read(path)
      end
    end
  end
end
