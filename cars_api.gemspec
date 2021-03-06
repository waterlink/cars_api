# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cars_api/version"

Gem::Specification.new do |spec|
  spec.name          = "cars_api"
  spec.version       = CarsApi::VERSION
  spec.authors       = ["Oleksii Fedorov"]
  spec.email         = ["waterlink000@gmail.com"]

  spec.summary       = "A car sharing API."
  spec.homepage      = "https://github.com/waterlink/cars_api"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting "allowed_push_host", or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] =
      "http://non-existent-rubygems.example.org"
  else
    raise "
    RubyGems 2.0 or newer is required to
    protect against public gem pushes."
  end

  spec.files = `git ls-files -z`
               .split("\x0")
               .reject { |f| f.match(%r{^(test|spec|features)/}) }

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"

  # This is used only in InMemory implementations and in integration tests to
  # verify that real implementations return sane values.
  spec.add_dependency "geokit", "~> 1.10"

  # This is used for a nice DSL for command line application.
  spec.add_dependency "thor", "~> 0.19"

  # This is used for a web API server
  spec.add_dependency "sinatra", "~> 1.4"

  # This is a crate.io client
  spec.add_dependency "crate_ruby"
end
