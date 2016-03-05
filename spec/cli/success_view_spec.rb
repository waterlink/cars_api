require "cars_cli/success_view"

module CarsCli
  RSpec.describe SuccessView do
    it "renders success message" do
      expect(SuccessView[double("Response")].to_s)
        .to eq("Completed operation successfully")
    end
  end
end
