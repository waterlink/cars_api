require "cars_api/in_memory/data_source"

module CarsApi
  module InMemory
    RSpec.describe DataSource do
      let(:car_a) do
        {
          latitude: 51.378,
          longitude: 0.389,
          description: "car a"
        }
      end

      let(:car_b) do
        {
          latitude: 52.991,
          longitude: 1.56,
          description: "car b"
        }
      end

      let(:car_c) do
        {
          latitude: 32.78,
          longitude: 0.887,
          description: "car c"
        }
      end

      describe "#each" do
        it "never yields if empty" do
          source = DataSource.new([])
          expect do
            source.each do
              raise "should not yield"
            end
          end.not_to raise_error
        end

        it "yields exactly once when one car is present" do
          yielded = []
          source = DataSource.new([car_a])
          source.each do |data|
            yielded << data
          end
          expect(yielded).to eq([car_a])
        end

        it "yields all cars" do
          yielded = []
          source = DataSource.new([car_a, car_b, car_c])
          source.each do |data|
            yielded << data
          end
          expect(yielded).to eq([car_a, car_b, car_c])
        end
      end
    end
  end
end
