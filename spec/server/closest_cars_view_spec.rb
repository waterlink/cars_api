require "cars_server/closest_cars_view"

module CarsServer
  RSpec.describe ClosestCarsView do
    let(:cars) do
      [
        {
          description: "car a",
          latitude: 15.79,
          longitude: 19.31,
          distance: "3.5 miles"
        },

        {
          description: "car b",
          latitude: 15.27,
          longitude: 18.91,
          distance: "6.7 miles"
        }
      ]
    end

    let(:view) { ClosestCarsView[cars] }

    it "can be serialized to a json format" do
      expect(view.to_json).to eq(
        {
          cars: [
            {
              "description" => "car a",
              "latitude" => 15.79,
              "longitude" => 19.31,
              "distance" => "3.5 miles"
            },

            {
              "description" => "car b",
              "latitude" => 15.27,
              "longitude" => 18.91,
              "distance" => "6.7 miles"
            }
          ]
        }.to_json
      )
    end

    it "has status code 200" do
      expect(view.status).to eq(200)
    end
  end
end
