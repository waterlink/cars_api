require "thor"
require "yaml"

require "cars_cli"
require "cars_cli/import_command"

require "cars_api/initial_import/interactor"
require "cars_api/in_memory/car_store"
require "cars_api/get_closest_cars/interactor"

require "cars_server/app"

require "cars_util/simple_hash_builder"

# CarsCli is a CLI representation layer for CarsApi
module CarsCli
  # App is a CLI application for CarsApi
  class App < Thor
    SERVER_CONFIG_SPEC = CarsUtil::SimpleHashBuilder
                         .load_spec("server_config_spec")

    include CarsUtil::SimpleHashBuilder

    desc "import FILE", "Import car locations from JSON file"
    def import(file)
      command = CarsCli::ImportCommand.new(interactor_initial_import, file)
      view = command.call
      puts view.to_s
      p car_store
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

    def car_store
      @_car_store ||= CarsApi::InMemory::CarStore.new(
        [
          CarsApi::Car["the car 1", CarsApi::Location[12.79, 13.54]],
          CarsApi::Car["the car 2", CarsApi::Location[12.98, 13.44]]
        ]
      )
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
