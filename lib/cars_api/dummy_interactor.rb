module CarsApi
  # DummyInteractor represents a thing, that acts as an interactor
  class DummyInteractor
    attr_reader :request, :response

    def with_response(response)
      @response = response
      self
    end

    def call(request)
      @request = request
      response
    end
  end
end