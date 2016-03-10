require "cars_api/result"

module CarsApi
  RSpec.describe Result do
    it "can be an ok" do
      expect(Result.ok(42)).to eq(Result::Ok[42])
    end

    it "can be an error" do
      expect(Result.error("unable to find the answer"))
        .to eq(Result::Error["unable to find the answer"])
    end

    it "can be chained with when_ok when ok" do
      expect(Result.ok(37).when_ok { |value| value + 5 })
        .to eq(Result.ok(42))
    end

    it "shortcircuits with when_ok when error" do
      expect(Result.error("oops")
        .when_ok { |value| value + 5 })
        .to eq(Result.error("oops"))
    end

    it "can be chained with when_error when error" do
      expect(Result.error("oops")
        .when_error { :default_value })
        .to eq(Result.ok(:default_value))
    end

    it "shortcircuits with when_error when ok" do
      expect(Result.ok(42)
        .when_error { :default_value })
        .to eq(Result.ok(42))
    end

    it "joins when ok and value is result" do
      expect(Result.ok(Result.ok(42)).join)
        .to eq(Result.ok(42))

      expect(Result.ok(Result.error("oops")).join)
        .to eq(Result.error("oops"))
    end

    it "shortcircuits when ok and value is not a result" do
      expect(Result.ok(42).join).to eq(Result.ok(42))
    end

    it "shortcircuits when error on join" do
      expect(Result.error("oops").join)
        .to eq(Result.error("oops"))
    end

    it "is possible to construct from ruby value" do
      expect(Result.from(42) { "oops" })
        .to eq(Result.ok(42))

      expect(Result.from(nil) { "oops" })
        .to eq(Result.error("oops"))
    end

    it "is possible to construct from error message" do
      expect(Result.from_error("oops") { 42 })
        .to eq(Result.error("oops"))

      expect(Result.from_error(nil) { 42 })
        .to eq(Result.ok(42))
    end

    it "is possible to unwrap the value" do
      expect(Result.ok(42).unwrap!).to eq(42)

      expect { Result.error("oops").unwrap! }
        .to raise_error(ArgumentError, "Error(\"oops\") is not Ok.")
    end

    it "is possible to create result from block that raises" do
      expect(Result.do { 42 }).to eq(Result.ok(42))

      expect(Result.do { raise "oops" })
        .to eq(Result.error("oops"))
    end
  end
end
