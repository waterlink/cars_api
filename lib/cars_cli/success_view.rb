module CarsCli
  # SuccessViewStruct is a value object for SuccessView
  SuccessViewStruct = Struct.new(:_response)

  # SuccessView understands UI for successful operation
  class SuccessView < SuccessViewStruct
    def to_s
      "Completed operation successfully"
    end
  end
end
