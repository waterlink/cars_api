require "cars_server/get_closest_command"
require "cars_api/dummy_interactor"
require "cars_api/get_closest_cars"
require "cars_api/location"
require "cars_api/car_marker"

# rubocop:disable Metrics/ModuleLength
module CarsServer
  RSpec.describe GetClosestCommand do
    let(:dummy) { CarsApi::DummyInteractor }

    let(:location) { CarsApi::Location[12.7, 13.9] }
    let(:limit) { 10 }

    let(:marker_a) do
      CarsApi::CarMarker[
        CarsApi::Car[
          "car a",
          CarsApi::Location[12.67, 13.84]
        ],
        9
      ]
    end

    let(:marker_b) do
      CarsApi::CarMarker[
        CarsApi::Car[
          "car b",
          CarsApi::Location[12.5, 13.72]
        ],
        19
      ]
    end

    let(:units) { nil }
    let(:proper_units) { (units || :kms).to_sym }

    let(:raw_a) do
      {
        description: "car a",
        latitude: 12.67,
        longitude: 13.84,
        distance: "9 #{proper_units}"
      }
    end

    let(:raw_b) do
      {
        description: "car b",
        latitude: 12.5,
        longitude: 13.72,
        distance: "19 #{proper_units}"
      }
    end

    let(:interactor) do
      dummy.new.with_response(
        CarsApi::GetClosestCars::Response[[marker_a, marker_b]]
      )
    end

    let(:command) do
      GetClosestCommand.new(interactor, location, limit, units)
    end

    let(:view) { command.call }

    it "returns empty response when there is no data" do
      interactor = dummy.new.with_response(
        CarsApi::GetClosestCars::Response[[]]
      )
      command = GetClosestCommand.new(interactor, location, limit, nil)

      view = command.call
      expect(view).to eq(ClosestCarsView[[]])
    end

    it "returns a correct response when there is some data" do
      expect(view).to eq(ClosestCarsView[[raw_a, raw_b]])
    end

    it "passes a correct request to the interactor" do
      view
      expect(interactor.request).to eq(
        CarsApi::GetClosestCars::Request[
          location, 10, proper_units
        ]
      )
    end

    context "when limit is different" do
      let(:limit) { 5 }

      it "passes a correct request to the interactor" do
        view
        expect(interactor.request).to eq(
          CarsApi::GetClosestCars::Request[
            location, 5, proper_units
          ]
        )
      end
    end

    context "when units is kms" do
      let(:units) { "kms" }

      it "returns a correct response with kms in distance" do
        expect(view.cars[0][:distance]).to eq("9 kms")
      end
    end

    context "when units is miles" do
      let(:units) { "miles" }

      it "returns a correct response with miles in distance" do
        expect(view.cars[0][:distance]).to eq("9 miles")
      end

      it "passes a correct request to the interactor" do
        view
        expect(interactor.request).to eq(
          CarsApi::GetClosestCars::Request[
            location, 10, :miles
          ]
        )
      end
    end

    context "when units is something else" do
      let(:units) { "something else" }

      it "returns a correct response with kms in distance" do
        expect(view.cars[0][:distance]).to eq("9 kms")
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
