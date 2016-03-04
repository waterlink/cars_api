require "cars_api/initial_import/interactor"
require "cars_api/in_memory"

module CarsApi
  module InitialImport
    # FailingCarStoreStruct is a CarStore that fails, pure
    # value object
    FailingCarStoreStruct = Struct.new(:clear_error, :save_error)

    # FailingCarStore understands, how CarStore can fail
    class FailingCarStore < FailingCarStoreStruct
      def clear
        Result.from_error(clear_error) { nil }
      end

      def save(_car)
        Result.from_error(save_error) { nil }
      end
    end

    RSpec.describe Interactor do
      let(:car_a) { Car["Car a", Location[12.34, 56.78]] }
      let(:car_b) { Car["Car b", Location[23.45, 45.67]] }
      let(:car_c) { Car["Car c", Location[43.21, 54.32]] }

      let(:unable_to_clear_store) do
        FailingCarStore["unable to clear", nil]
      end

      let(:unable_to_save_store) do
        FailingCarStore[nil, "unable to save"]
      end

      let(:source_a) do
        {
          description: "Car a",
          latitude: 12.34,
          longitude: 56.78
        }
      end

      let(:source_b) do
        {
          description: "Car b",
          latitude: 23.45,
          longitude: 45.67
        }
      end

      it "stores nothing when data source is empty" do
        source = InMemory::DataSource.new
        request = Request[source]
        store = InMemory::CarStore.new
        interactor = Interactor.new(store)

        expect(interactor.call(request))
          .to eq(Response[true, nil])
        expect(store).to eq(InMemory::CarStore.new([]))
      end

      it "resets existing data" do
        source = InMemory::DataSource.new
        request = Request[source]
        store = InMemory::CarStore.new(
          [car_a, car_b, car_c]
        )
        interactor = Interactor.new(store)

        expect(interactor.call(request))
          .to eq(Response[true, nil])
        expect(store).to eq(InMemory::CarStore.new([]))
      end

      it "stores data from the data source" do
        source = InMemory::DataSource.new(
          [source_b, source_a]
        )
        request = Request[source]
        store = InMemory::CarStore.new([car_a, car_c])
        interactor = Interactor.new(store)

        expect(interactor.call(request))
          .to eq(Response[true, nil])
        expect(store).to eq(InMemory::CarStore.new([car_b, car_a]))
      end

      it "fails when car store fails to clear data" do
        source = InMemory::DataSource.new(
          [source_b, source_a]
        )
        request = Request[source]
        store = unable_to_clear_store
        interactor = Interactor.new(store)

        expect(interactor.call(request))
          .to eq(Response[false, "unable to clear"])
      end

      it "fails when car store fails to save data" do
        source = InMemory::DataSource.new(
          [source_b, source_a]
        )
        request = Request[source]
        store = unable_to_save_store
        interactor = Interactor.new(store)

        expect(interactor.call(request))
          .to eq(Response[false, "unable to save"])
      end
    end
  end
end
