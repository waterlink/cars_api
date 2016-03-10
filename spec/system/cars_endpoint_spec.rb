require "json"

RSpec.describe "System tests" do
  describe "/cars API endpoint" do
    let!(:pipe) { open("|cars_api server --server=webrick") }

    after do
      Process.kill("INT", pipe.pid)
    end

    context "when car store is empty" do
      it "is empty" do
        `cars_api import ./spec/fixtures/empty.json`
        markers = fetch_data
        expect(markers["cars"].count).to eq(0)
      end
    end

    context "when car store has something" do
      it "returns some car markers" do
        `cars_api import ./spec/fixtures/data.json`
        markers = fetch_data
        expect(markers["cars"].count).to be > 0
      end
    end

    def fetch_data(retries = 30)
      raise "Unable to fetch data" if retries < 0

      output = `curl localhost:4567/cars?location=45.67,23.37 2>/dev/null`
      begin
        JSON.parse(output)
      rescue
        sleep(0.5)
        fetch_data(retries - 1)
      end
    end
  end
end
