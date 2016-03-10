require "cars_server/internal_error"
require "json"

module CarsServer
  RSpec.describe InternalError do
    subject(:view) { InternalError["specific error"] }

    it "hides the detailed message" do
      expect(view.to_json).to eq({
        error: "Internal error"
      }.to_json)
    end

    it "has status 500" do
      expect(view.status).to eq(500)
    end
  end
end
