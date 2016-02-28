require "cars_api/get_closest_cars/interactor"
require "cars_api/in_memory/car_store"

module CarsApi
  module GetClosestCars
    RSpec.describe Interactor do
      let(:car_1) { Car["Car 1", Location[12, 15]] }
      let(:car_2) { Car["Car 2", Location[12.2, 15.1]] }
      let(:car_3) { Car["Car 3", Location[11.7, 15.4]] }
      let(:car_4) { Car["Car 4", Location[12.1, 14.9]] }

      let(:car_store) { InMemory::CarStore.new([
        car_1, car_2, car_3, car_4,
      ]) }
      
      let(:location) { Location[11.9, 15.2] }

      subject(:interactor) { Interactor.new(car_store) }

      it "returns an empty response when N=0" do
        car_store = InMemory::CarStore.new
        request = Request[location, 0]
        interactor = Interactor.new(car_store)

        response = interactor.call(request)

        expect(response).to eq(Response[[]])
      end

      it "returns an empty response when there are no cars" do
        car_store = InMemory::CarStore.new
        request = Request[location, 10]
        interactor = Interactor.new(car_store)

        response = interactor.call(request)

        expect(response).to eq(Response[[]])
      end

      it "returns response with cars when there are some cars" do
        request = Request[location, 10]
        response = interactor.call(request)
        expect(response.cars.map(&:car)).to eq([
          car_1, car_3, car_2, car_4,
        ])

        request = Request[location, 2]
        response = interactor.call(request)
        expect(response.cars.map(&:car)).to eq([
          car_1, car_3,
        ])
      end

      it "returns response with distances in kms" do
        request = Request[location, 2]
        response = interactor.call(request)

        expected = [24.45, 31.14]
          .map { |x| be_within(0.01).of(x) }
        expect(response.cars.map(&:distance))
          .to match(expected)

        request = Request[location, 2, :kms]
        response = interactor.call(request)

        expected = [24.45, 31.14]
          .map { |x| be_within(0.01).of(x) }
        expect(response.cars.map(&:distance))
          .to match(expected)
      end

      it "returns response with distances in miles" do
        request = Request[location, 2, :miles]
        response = interactor.call(request)

        expected = [15.19, 19.35]
          .map { |x| be_within(0.01).of(x) }
        expect(response.cars.map(&:distance))
          .to match(expected)
      end
    end
  end
end
