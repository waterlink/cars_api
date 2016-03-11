require "json"

{
  # CLI options => rspec tags
  "" => [:very_slow],
  "--car-store=crate-io \
   --crate-io-car-table=cars_api_test_cars" => [:very_slow, :crate_io]
}.each do |capture_cli_options, capture_rspec_tags|
  RSpec.describe "System tests (#{capture_cli_options})", *capture_rspec_tags do
    let(:cli_options) { capture_cli_options }
    let(:rspec_tags) { capture_rspec_tags }

    describe "/cars API endpoint" do
      let(:port) { rand(50_000..55_000) }

      let!(:pipe) do
        open(
          "|bundle exec cars_api server \
              --server=webrick \
              --server-port=#{port} \
              #{cli_options}"
        )
      end

      after do
        Process.kill("INT", pipe.pid)
      end

      context "when car store is empty" do
        it "is empty" do
          import("./spec/fixtures/empty.json")
          markers = fetch_data
          expect(markers["cars"].count).to eq(0)
        end
      end

      context "when car store has something" do
        it "returns some car markers" do
          import("./spec/fixtures/data.json")
          markers = fetch_data
          expect(markers["cars"].count).to be > 0
        end
      end

      def import(file_path)
        `bundle exec cars_api import #{cli_options} #{file_path}`
        # Give chance eventual consistency to happen (default refresh interval
        # is 1000 ms, so 1500 ms should be enough)
        sleep(1.5) if rspec_tags.include?(:crate_io)
      end

      def fetch_data(retries = 30)
        raise "Unable to fetch data" if retries < 0

        output = `curl localhost:#{port}/cars?location=45.67,23.37 2>/dev/null`
        begin
          JSON.parse(output)
        rescue
          sleep(0.5)
          fetch_data(retries - 1)
        end
      end
    end
  end
end
