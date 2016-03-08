require "cars_server/location_parser"

module CarsServer
  RSpec.describe LocationParser do
    it "parses valid location" do
      params = { location: "37.54,-2.38" }
      location = LocationParser.new(params).location
      expect(location).to eq(
        CarsApi::Result.ok(
          CarsApi::Location[37.54, -2.38]
        )
      )

      params = { location: "21.03,42.14" }
      location = LocationParser.new(params).location
      expect(location).to eq(
        CarsApi::Result.ok(
          CarsApi::Location[21.03, 42.14]
        )
      )
    end

    it "rejects invalid location" do
      params = { location: "37.54 -2.38" }
      location = LocationParser.new(params).location
      expect(location).to eq(
        CarsApi::Result.error(
          LocationParser::INVALID_LONGITUDE
        )
      )

      params = { location: "" }
      location = LocationParser.new(params).location
      expect(location).to eq(
        CarsApi::Result.error(
          LocationParser::INVALID_LATITUDE
        )
      )

      params = { location: nil }
      location = LocationParser.new(params).location
      expect(location).to eq(
        CarsApi::Result.error(
          LocationParser::MISSING_LOCATION
        )
      )
    end
  end
end
