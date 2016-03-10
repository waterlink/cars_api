require "json"

module CarsServer
  # ClientErrorStruct is a value object for InternalError view
  ClientErrorStruct = Struct.new(:message)

  # ClientError is a view for any unexpected error
  class ClientError < ClientErrorStruct
    def to_json
      { error: message }.to_json
    end

    def status
      400
    end
  end
end
