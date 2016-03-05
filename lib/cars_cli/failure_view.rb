module CarsCli
  # FailureViewStruct is a value object for FailureView
  FailureViewStruct = Struct.new(:response)

  # FailureView understands UI for failed operations
  class FailureView < FailureViewStruct
    def to_s
      "Internal error: #{response.error}"
    end
  end
end
