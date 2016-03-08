require "cars_util"
require "yaml"

module CarsUtil
  # SimpleHashBuilder allows to build big flat hashes using constant
  # specification
  module SimpleHashBuilder
    def self.load_spec(name)
      YAML
        .load_file(File.join(".", "config", "#{name}.yml"))
        .freeze
    end

    def build_hash_with(spec)
      spec.each_with_object({}) do |(key, name), hash|
        hash[key] = send(name)
      end
    end
  end
end
