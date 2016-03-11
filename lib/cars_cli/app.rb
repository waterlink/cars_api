require "thor"
require "yaml"

require "cars_cli"
require "cars_cli/import_command"

require "cars_api/initial_import/interactor"
require "cars_api/get_closest_cars/interactor"

require "cars_api/in_memory/car_store"
require "cars_api/file_based/car_store"
require "cars_api/crate_io/car_store"

require "cars_server/app"

require "cars_util/simple_hash_builder"

# CarsCli is a CLI representation layer for CarsApi
module CarsCli
  # CarStoreOptions knows about different CarStore implementations
  module CarStoreOptions
    # InMemoryCarStore knows how to build an in-memory CarStore
    class InMemoryCarStore
      def self.build(_options)
        CarsApi::InMemory::CarStore.new(
          [
            CarsApi::Car["the car 1", CarsApi::Location[12.79, 13.54]],
            CarsApi::Car["the car 2", CarsApi::Location[12.98, 13.44]]
          ]
        )
      end
    end

    # FileBasedCarStore knows how to build a file-based CarStore
    class FileBasedCarStore
      def self.build(options)
        CarsApi::FileBased::CarStore.new(options[:file_based_path])
      end
    end

    # CrateIOCarStore knows how to build a crate.io backed CarStore
    class CrateIOCarStore
      DEFAULT_HTTP_OPTIONS = {
        read_timeout: 3600
      }.freeze

      def self.build(options)
        new(options).build
      end

      def initialize(options)
        @options = options
      end

      def build
        CarsApi::CrateIO::CarStore.new(
          options[:crate_io_car_table],
          connection: connection
        )
      end

      private

      attr_reader :options

      def connection
        CrateRuby::Client.new(options[:crate_io_servers], http_options)
      end

      # TODO: see if support of some sort of auth is possible
      # Most probably would require a PR to https://github.com/crate/crate_ruby/
      def http_options
        DEFAULT_HTTP_OPTIONS
      end
    end

    CAR_STORE_ADAPTERS = {
      "in-memory" => InMemoryCarStore,
      "file-based" => FileBasedCarStore,
      "crate-io" => CrateIOCarStore
    }.freeze

    DEFAULT_CAR_STORE = "file-based".freeze
    DEFAULT_FILE_BASED_PATH = "./car_store.json".freeze
    DEFAULT_CRATE_IO_CAR_TABLE = "cars_api_development_cars".freeze
    DEFAULT_CRATE_IO_SERVERS = ["localhost:4200"].freeze

    CLASS_OPTIONS = {
      car_store: {
        default: DEFAULT_CAR_STORE,
        type: :string,
        enum: CAR_STORE_ADAPTERS.keys,
        desc: "CarStore adapter to use"
      },

      file_based_path: {
        default: DEFAULT_FILE_BASED_PATH,
        type: :string,
        desc: "File based CarStore file path"
      },

      crate_io_car_table: {
        default: DEFAULT_CRATE_IO_CAR_TABLE,
        type: :string,
        desc: "Table name to store cars in"
      },

      crate_io_servers: {
        default: DEFAULT_CRATE_IO_SERVERS,
        type: :array,
        desc: "Servers to connect to for crate.io backed CarStore"
      }
    }.freeze

    def self.included(base)
      super
      CLASS_OPTIONS.each { |name, opts| base.class_option(name, opts) }
    end

    private

    def car_store
      @_car_store ||= car_store_factory.build(options)
    end

    def car_store_factory
      CAR_STORE_ADAPTERS.fetch(options[:car_store])
    end
  end

  # App is a CLI application for CarsApi
  class App < Thor
    SERVER_CONFIG_SPEC = CarsUtil::SimpleHashBuilder
                         .load_spec("server_config_spec")

    include CarsUtil::SimpleHashBuilder

    include CarStoreOptions

    desc "import FILE", "Import car locations from JSON file"
    def import(file)
      command = CarsCli::ImportCommand.new(interactor_initial_import, file)
      view = command.call
      puts view.to_s
    end

    desc "server", "Start API server"
    method_option(
      :server,
      default: "thin",
      type: :string,
      desc: "Server to use"
    )
    method_option(
      :server_require,
      default: nil,
      type: :string,
      desc: "Custom require to load server library (default=(--server value))"
    )
    method_option(
      :server_port,
      default: 4567,
      type: :numeric,
      desc: "Custom port to run server on"
    )
    method_option(
      :server_bind,
      default: "localhost",
      type: :string,
      desc: "Custom ip address to bind server to"
    )
    def server
      require_server_library
      setup_server
      run_server
    end

    private

    def run_server
      server_class.run!
    end

    def setup_server
      server_config.each do |setting, value|
        server_class.set(setting, value)
      end
    end

    def server_class
      CarsServer::App
    end

    def server_config
      build_hash_with(SERVER_CONFIG_SPEC)
    end

    def server_bind
      options[:server_bind]
    end

    def server_port
      options[:server_port]
    end

    def server_type
      options[:server].to_sym
    end

    def require_server_library
      require server_library
    end

    def server_library
      options[:server_require] || options[:server]
    end

    def interactor_initial_import
      @_interactor_initial_import ||= interactor(CarsApi::InitialImport)
    end

    def interactor_get_closest
      @_interactor_get_closest ||= interactor(CarsApi::GetClosestCars)
    end

    def interactor(klass)
      klass::Interactor.new(car_store)
    end
  end

  App.start
end
