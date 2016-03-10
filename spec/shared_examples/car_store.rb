require "cars_api/get_closest_cars"
require "cars_api/initial_import"
require "cars_api/location"
require "cars_api/result"

module CarsApi
  RSpec.shared_examples "CarStore" do
    describe GetClosestCars::CarStoreProtocol do
      describe "#get_closest(location, limit)" do
        let(:location) { Location[51.5444204, -0.22707] }
        it "returns empty when no data" do
          cars = empty
                 .get_closest(location, 10)
                 .unwrap!
                 .map(&:car)
          expect(cars).to eq([])
        end

        it "returns exactly limit cars" do
          store = some_cars

          cars = store.get_closest(location, 0).unwrap!
          expect(cars.map(&:car)).to eq([])

          cars = store.get_closest(location, 1).unwrap!
          expect(cars.map(&:car)).to eq([car_b])

          cars = store.get_closest(location, 2).unwrap!
          expect(cars.map(&:car)).to eq([car_b, car_c])

          cars = store.get_closest(location, 3).unwrap!
          expect(cars.map(&:car)).to eq([car_b, car_c, car_a])
        end

        it "returns as much as it has when limit is big" do
          store = two_cars
          cars = store.get_closest(location, 10).unwrap!
          expect(cars.map(&:car)).to eq([car_b, car_c])
        end

        it "returns correct distances" do
          store = two_cars

          cars = store.get_closest(location, 10).unwrap!
          expected = [6.18, 6.98]
                     .map { |distance| be_within(0.01).of(distance) }

          expect(cars.map(&:distance))
            .to match(expected)
        end

        it "returns distances in kms" do
          store = two_cars

          cars = store.get_closest(location, 10, :kms).unwrap!
          expected = [6.18, 6.98]
                     .map { |distance| be_within(0.01).of(distance) }

          expect(cars.map(&:distance))
            .to match(expected)
        end

        it "returns distances in miles" do
          store = two_cars

          cars = store.get_closest(location, 10, :miles).unwrap!
          expected = [3.84, 4.34]
                     .map { |distance| be_within(0.01).of(distance) }

          expect(cars.map(&:distance))
            .to match(expected)
        end

        it "orders car markers by distance" do
          expect(some_cars
            .get_closest(location, 10)
            .unwrap!
            .map(&:car))
            .to eq([car_b, car_c, car_a])

          expect(other_cars
            .get_closest(location, 10)
            .unwrap!
            .map(&:car))
            .to eq([car_b, car_c, car_a])
        end

        it "picks best limit cars by distance" do
          expect(some_cars
            .get_closest(location, 2)
            .unwrap!
            .map(&:car))
            .to eq([car_b, car_c])
        end
      end
    end

    describe InitialImport::CarStoreProtocol do
      describe "#clear" do
        it "clears data from the car store" do
          store = couple_of_cars
          store.clear
          expect(store).to eq(empty)
        end

        it "returns ok" do
          store = couple_of_cars
          expect(store.clear).to eq(Result.ok(nil))
        end
      end

      describe "#save" do
        it "stores car data in the car store" do
          store = empty

          store.save(car_b)
          expect(store).to eq(car_b_added)

          store.save(car_a)
          expect(store).to eq(and_car_a_added)
        end

        it "returns ok" do
          store = empty
          expect(store.save(car_b)).to eq(Result.ok(nil))
        end
      end
    end
  end
end
