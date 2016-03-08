require "cars_server"
require "json"

module CarsServer
  # ClosestCarsViewStruct is a value object for ClosestCars view
  ClosestCarsViewStruct = Struct.new(:cars)

  # ClosestCarsView is an API view for GetClosestCars use case
  class ClosestCarsView < ClosestCarsViewStruct
    def to_json
      @_to_json ||= with_root_object.to_json
    end

    private

    def with_root_object
      { cars: cars }
    end
  end
end
