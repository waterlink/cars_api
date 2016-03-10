require "shared_examples/car_store"

require "cars_api"
require "cars_api/location"
require "cars_api/in_memory/car_store"

module CarsApi
  module InMemory
    RSpec.describe CarStore do
      let(:car_a) { Car["First", Location[51.511318, -0.318178]] }
      let(:car_b) { Car["Second", Location[51.553667, -0.315159]] }
      let(:car_c) { Car["Third", Location[51.512107, -0.313599]] }

      subject(:empty) { CarStore.new([]) }
      subject(:two_cars) { CarStore.new([car_b, car_c]) }
      subject(:couple_of_cars) { CarStore.new([car_a, car_b]) }
      subject(:some_cars) { CarStore.new([car_a, car_b, car_c]) }
      subject(:other_cars) { CarStore.new([car_b, car_a, car_c]) }

      subject(:car_b_added) { CarStore.new([car_b]) }
      subject(:and_car_a_added) { CarStore.new([car_b, car_a]) }

      it_behaves_like "CarStore"
    end
  end
end
