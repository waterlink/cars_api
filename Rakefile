require "bundler/gem_tasks"

begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
  puts "Unable to load RSpec rake task"
end

begin
  require "flog_task"

  FlogTask.new(name = :flog, threshold = 10, dirs = ["lib"], method = :max_method)
rescue LoadError
  puts "Unable to load Flog rake task"
end
