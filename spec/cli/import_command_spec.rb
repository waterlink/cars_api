require "cars_cli/import_command"

module CarsCli
  RSpec.describe ImportCommand do
    let(:car_a) do
      {
        description: "Car a",
        latitude: 12.34,
        longitude: 56.78
      }
    end

    let(:car_b) do
      {
        description: "Car b",
        latitude: 23.45,
        longitude: 45.67
      }
    end

    let(:success) do
      CarsApi::InitialImport::Response[true, nil]
    end

    let(:failure) do
      CarsApi::InitialImport::Response[false, "a failure"]
    end

    it "requests interactor with empty datastore" do
      interactor = DummyInteractor.new.with_response(success)
      command = ImportCommand.new(
        interactor,
        "./spec/fixtures/empty.json"
      )

      expected = []
      actual = []

      command.call
      interactor.request.data_source.each do |data|
        actual << data
      end

      expect(actual).to eq(expected)
    end

    it "requests interactor with some datastore" do
      interactor = DummyInteractor.new.with_response(success)
      command = ImportCommand.new(
        interactor,
        "./spec/fixtures/data.json"
      )

      expected = [car_a, car_b]
      actual = []

      command.call
      interactor.request.data_source.each do |data|
        actual << data
      end

      expect(actual).to eq(expected)
    end

    it "returns a success view, when successful" do
      interactor = DummyInteractor.new.with_response(success)
      command = ImportCommand.new(
        interactor,
        "./spec/fixtures/data.json"
      )

      expect(command.call).to eq(SuccessView[success])
    end

    it "returns a failure view, when failure" do
      interactor = DummyInteractor.new.with_response(failure)
      command = ImportCommand.new(
        interactor,
        "./spec/fixtures/data.json"
      )

      expect(command.call).to eq(FailureView[failure])
    end
  end
end
