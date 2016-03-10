require "json"

module CarsServer
  # InternalErrorStruct is a value object for InternalError view
  InternalErrorStruct = Struct.new(:message)

  # InternalError is a view for any unexpected error
  class InternalError < InternalErrorStruct
    INTERNAL_ERROR_MESSAGE = "Internal error".freeze

    # suppress :reek:UtilityFunction
    def to_json
      { error: INTERNAL_ERROR_MESSAGE }.to_json
    end

    def status
      500
    end
  end
end
