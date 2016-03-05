require "thor"

require "cars_cli"
require "cars_cli/import_command"
require "cars_api/initial_import/interactor"
require "cars_api/in_memory/car_store"

# CarsCli is a CLI representation layer for CarsApi
module CarsCli
  # App is a CLI application for CarsApi
  class App < Thor
    desc "import FILE", "Import car locations from JSON file"
    def import(file)
      command = CarsCli::ImportCommand.new(initial_import, file)
      view = command.call
      puts view.to_s
      p car_store
    end

    private

    def car_store
      @_car_store ||= CarsApi::InMemory::CarStore.new
    end

    def initial_import
      @_initial_import ||= CarsApi::InitialImport::Interactor.new(car_store)
    end
  end

  App.start
end
