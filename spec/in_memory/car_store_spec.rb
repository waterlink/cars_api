require "cars_api/in_memory/car_store"
require "cars_api/get_closest_cars"
require "cars_api/initial_import"
require "cars_api/location"

module CarsApi
  # rubocop:disable Metrics/ModuleLength
  module InMemory
    RSpec.describe CarStore do
      let(:car_a) { Car["First", Location[51.511318, -0.318178]] }
      let(:car_b) { Car["Second", Location[51.553667, -0.315159]] }
      let(:car_c) { Car["Third", Location[51.512107, -0.313599]] }

      describe GetClosestCars::CarStoreProtocol do
        describe "#get_closest(location, limit)" do
          let(:location) { Location[51.5444204, -0.22707] }
          it "returns empty when no data" do
            cars = CarStore
                   .new
                   .get_closest(location, 10)
                   .map(&:car)
            expect(cars).to eq([])
          end

          it "returns exactly limit cars" do
            store = CarStore.new([car_a, car_b, car_c])

            cars = store.get_closest(location, 0)
            expect(cars.map(&:car)).to eq([])

            cars = store.get_closest(location, 1)
            expect(cars.map(&:car)).to eq([car_b])

            cars = store.get_closest(location, 2)
            expect(cars.map(&:car)).to eq([car_b, car_c])

            cars = store.get_closest(location, 3)
            expect(cars.map(&:car)).to eq([car_b, car_c, car_a])
          end

          it "returns as much as it has when limit is big" do
            store = CarStore.new([car_b, car_c])
            cars = store.get_closest(location, 10)
            expect(cars.map(&:car)).to eq([car_b, car_c])
          end

          it "returns correct distances" do
            store = CarStore.new([car_b, car_c])

            cars = store.get_closest(location, 10)
            expected = [6.18, 6.98]
                       .map { |distance| be_within(0.01).of(distance) }

            expect(cars.map(&:distance))
              .to match(expected)
          end

          it "returns distances in kms" do
            store = CarStore.new([car_b, car_c])

            cars = store.get_closest(location, 10, :kms)
            expected = [6.18, 6.98]
                       .map { |distance| be_within(0.01).of(distance) }

            expect(cars.map(&:distance))
              .to match(expected)
          end

          it "returns distances in miles" do
            store = CarStore.new([car_b, car_c])

            cars = store.get_closest(location, 10, :miles)
            expected = [3.84, 4.34]
                       .map { |distance| be_within(0.01).of(distance) }

            expect(cars.map(&:distance))
              .to match(expected)
          end

          it "orders car markers by distance" do
            expect(CarStore
              .new([car_a, car_b, car_c])
              .get_closest(location, 10)
              .map(&:car))
              .to eq([car_b, car_c, car_a])

            expect(CarStore
              .new([car_b, car_a, car_c])
              .get_closest(location, 10)
              .map(&:car))
              .to eq([car_b, car_c, car_a])
          end

          it "picks best limit cars by distance" do
            expect(CarStore
              .new([car_a, car_b, car_c])
              .get_closest(location, 2)
              .map(&:car))
              .to eq([car_b, car_c])
          end
        end
      end

      describe InitialImport::CarStoreProtocol do
        describe "#clear" do
          it "clears data from the car store" do
            store = CarStore.new([car_a, car_b])
            store.clear
            expect(store).to eq(CarStore.new([]))
          end

          it "returns ok" do
            store = CarStore.new([car_a, car_b])
            expect(store.clear).to eq(Result.ok(nil))
          end
        end

        describe "#save" do
          it "stores car data in the car store" do
            store = CarStore.new([])

            store.save(car_b)
            expect(store).to eq(CarStore.new([car_b]))

            store.save(car_a)
            expect(store).to eq(
              CarStore.new([car_b, car_a])
            )
          end

          it "returns nil" do
            store = CarStore.new([])
            expect(store.save(car_b)).to eq(Result.ok(nil))
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/ModuleLength
end
