require "sinatra/base"

require "cars_api/location"

require "cars_server/get_closest_command"
require "cars_server/get_closest_controller"
require "cars_server/location_parser"
require "cars_server/limit_parser"

module CarsServer
  # App is a web server application for CarsApi
  class App < Sinatra::Base
    CONTENT_TYPE = "application/json".freeze

    before { content_type CONTENT_TYPE }

    get "/cars" do
      controller_get_closest.render
    end

    def interactor_get_closest
      settings.interactor_get_closest
    end

    def controller_get_closest
      GetClosestController.new(
        params,
        interactor_get_closest
      )
    end
  end
end
