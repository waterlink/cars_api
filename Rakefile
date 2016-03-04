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

  FlogTask.new(
    _name = :flog,
    _threshold = 10,
    _dirs = ["lib"],
    _method = :max_method
  )
rescue LoadError
  puts "Unable to load Flog rake task"
end
