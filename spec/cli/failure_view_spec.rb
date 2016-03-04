require "cars_cli/failure_view"
require "cars_api/initial_import"

module CarsCli
  RSpec.describe FailureView do
    it "renders view with error message" do
      response = CarsApi::InitialImport::Response[
        false,
        "something failed"
      ]

      view = FailureView[response]

      expect(view.to_s).to eq("Internal error: something failed")
    end
  end
end
