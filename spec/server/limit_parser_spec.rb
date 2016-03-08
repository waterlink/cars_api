require "cars_server/limit_parser"

module CarsServer
  RSpec.describe LimitParser do
    it "defaults to default_limit" do
      expect(LimitParser.new({}, default_limit: 7).limit)
        .to eq(7)

      expect(LimitParser.new({}, default_limit: 9).limit)
        .to eq(9)
    end

    it "parses normal limit successfully" do
      params = { limit: "5" }
      expect(LimitParser.new(params).limit)
        .to eq(5)
    end

    it "ignores limits more than max_limit" do
      expect(LimitParser.new({ limit: "37" }, max_limit: 15).limit)
        .to eq(15)

      expect(LimitParser.new({ limit: "37" }, max_limit: 25).limit)
        .to eq(25)
    end
  end
end
