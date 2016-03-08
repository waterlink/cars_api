require "cars_server/get_closest_controller"
require "cars_server/location_parser"
require "cars_api/get_closest_cars/interactor"
require "cars_api/in_memory/car_store"

module CarsServer
  RSpec.describe GetClosestController do
    subject(:controller) { GetClosestController }

    let(:loc) { "12.37,14.59" }

    let(:all_cars) do
      [
        {
          description: "car a",
          latitude: 12.44,
          longitude: 14.57,
          distance: "8.1 kms"
        },

        {
          description: "car b",
          latitude: 12.39,
          longitude: 14.87,
          distance: "31 kms"
        }
      ]
    end

    let(:all_cars_in_miles) do
      [
        {
          description: "car a",
          latitude: 12.44,
          longitude: 14.57,
          distance: "5 miles"
        },

        {
          description: "car b",
          latitude: 12.39,
          longitude: 14.87,
          distance: "19 miles"
        }
      ]
    end

    let(:car_store) do
      CarsApi::InMemory::CarStore.new(
        [
          CarsApi::Car["car a", CarsApi::Location[12.44, 14.57]],
          CarsApi::Car["car b", CarsApi::Location[12.39, 14.87]]
        ]
      )
    end

    let(:interactor) do
      CarsApi::GetClosestCars::Interactor.new(car_store)
    end

    it "fails when called without query params" do
      expect(controller.new({}, interactor).render)
        .to eq({ error: LocationParser::MISSING_LOCATION }.to_json)
    end

    it "fails when called with invalid location" do
      expect(controller.new({ location: "" }, interactor).render)
        .to eq({ error: LocationParser::INVALID_LATITUDE }.to_json)

      expect(controller.new({ location: "3.5" }, interactor).render)
        .to eq({ error: LocationParser::INVALID_LONGITUDE }.to_json)
    end

    it "returns some car markers when limit is not set" do
      expect(controller.new({ location: loc }, interactor).render)
        .to eq({ cars: all_cars }.to_json)
    end

    context "when limit is smaller than count of cars to return" do
      it "returns first limit markers" do
        expect(controller.new({ location: loc, limit: "1" }, interactor).render)
          .to eq({ cars: [all_cars[0]] }.to_json)
      end
    end

    context "when limit is bigger than count of cars to return" do
      it "returns all cars markers" do
        expect(controller.new({ location: loc, limit: "5" }, interactor).render)
          .to eq({ cars: all_cars }.to_json)
      end
    end

    context "when limit is zero" do
      it "returns empty list" do
        expect(controller.new({ location: loc, limit: "0" }, interactor).render)
          .to eq({ cars: [] }.to_json)
      end
    end

    it "returns distances in kms when units is invalid" do
      params = { location: loc, units: "some" }
      expect(controller.new(params, interactor).render)
        .to eq({ cars: all_cars }.to_json)
    end

    it "returns distances in miles when units is miles" do
      params = { location: loc, units: "miles" }
      expect(controller.new(params, interactor).render)
        .to eq({ cars: all_cars_in_miles }.to_json)
    end
  end
end
