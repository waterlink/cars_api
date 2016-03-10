require "cars_server/location_parser"
require "cars_server/limit_parser"
require "cars_server/get_closest_command"
require "cars_server/client_error"

module CarsServer
  # GetClosestController understands input and output format of the
  # GetClosestCars use case
  class GetClosestController
    def initialize(params, interactor)
      @params = params
      @interactor = interactor
    end

    def render
      [view.status, {}, view.to_json]
    end

    private

    attr_reader :params, :interactor

    def view
      call_command
        .when_error { |message| ClientError[message] }
        .unwrap!
    end

    def _command(loc)
      CarsServer::GetClosestCommand.new(
        interactor,
        loc,
        limit,
        units
      )
    end

    def command
      method(:_command)
    end

    def call_command
      build_command.when_ok(&:call)
    end

    def build_command
      location.when_ok(&command)
    end

    def location
      LocationParser.new(params).location
    end

    def limit
      LimitParser.new(params).limit
    end

    def units
      params[:units]
    end
  end
end
