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

      let(:no_such_file) { "./spec/tmp/no-such-file.json" }

      subject(:empty) { fixture("empty") }
      subject(:two_cars) { fixture("two_cars") }
      subject(:couple_of_cars) { fixture("couple_of_cars") }
      subject(:some_cars) { fixture("some_cars") }
      subject(:other_cars) { fixture("other_cars") }

      subject(:car_b_added) { fixture("car_b_added") }
      subject(:and_car_a_added) { fixture("and_car_a_added") }

      let(:tempfiles) { [] }

      it_behaves_like "CarStore"

      it "is empty when file is missing" do
        store = CarStore.new(no_such_file)
        expect(store).to eq(empty)
      end

      it "reloads when file changes" do
        location = Location[12.55, 13.53]

        store = CarStore.new(no_such_file)
        expect(store.get_closest(location, 10).unwrap!.count).to eq(0)

        File.write(
          no_such_file,
          File.read(fixture_path_for("couple_of_cars"))
        )

        expect(store.get_closest(location, 10).unwrap!.count).to eq(2)
      end

      before do
        delete_no_such_file_json
      end

      after do
        tempfiles.each(&:unlink)
        delete_no_such_file_json
      end

      # suppress :reek:FeatureEnvy
      # suppress :reek:TooManyStatements
      def fixture(name)
        tempfile = Tempfile.new("car_store")
        tempfiles << tempfile

        tempfile.write(File.read(fixture_path_for(name)))
        tempfile.close

        CarStore.new(tempfile.path)
      end

      # suppress :reek:FeatureEnvy
      def fixture_path_for(name)
        "./spec/fixtures/car_store/#{name}.json"
      end

      def delete_no_such_file_json
        File.delete(no_such_file)
      rescue
        puts "[WARN] unable to delete #{no_such_file}"
      end
    end
  end
end
