require "cars_server/client_error"

module CarsServer
  RSpec.describe ClientError do
    subject(:view) { ClientError["Incorrect query"] }

    it "renders correct response" do
      expect(view.to_json).to eq({
        error: "Incorrect query"
      }.to_json)
    end

    it "returns correct status error" do
      expect(view.status).to eq(400)
    end
  end
end
