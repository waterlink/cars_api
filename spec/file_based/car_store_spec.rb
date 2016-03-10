require "tempfile"

require "shared_examples/car_store"

require "cars_api"
require "cars_api/location"
require "cars_api/file_based/car_store"

module CarsApi
  # suppress :reek:IrresponsibleModule
  module FileBased
    RSpec.describe CarStore do
      let(:car_a) { Car["First", Location[51.511318, -0.318178]] }
      let(:car_b) { Car["Second", Location[51.553667, -0.315159]] }
      let(:car_c) { Car["Third", Location[51.512107, -0.313599]] }

      subject(:empty) { fixture("empty") }
      subject(:two_cars) { fixture("two_cars") }
      subject(:couple_of_cars) { fixture("couple_of_cars") }
      subject(:some_cars) { fixture("some_cars") }
      subject(:other_cars) { fixture("other_cars") }

      subject(:car_b_added) { fixture("car_b_added") }
      subject(:and_car_a_added) { fixture("and_car_a_added") }

      it_behaves_like "CarStore"

      let(:tempfiles) { [] }

      after do
        tempfiles.each(&:unlink)
      end

      # suppress :reek:FeatureEnvy
      # suppress :reek:TooManyStatements
      def fixture(name)
        fixture_path = "./spec/fixtures/car_store/#{name}.json"

        tempfile = Tempfile.new("car_store")
        tempfiles << tempfile

        tempfile.write(File.read(fixture_path))
        tempfile.close

        CarStore.new(tempfile.path)
      end
    end
  end
end
