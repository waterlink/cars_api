require "bundler/gem_tasks"

code_dirs = ["lib"]

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
    _dirs = code_dirs,
    _method = :max_method,
    _methods_only = true
  )
rescue LoadError
  puts "Unable to load Flog rake task"
end

begin
  require "flay_task"

  # CustomFlayTask allows to change default mass_threshold
  class CustomFlayTask < FlayTask
    def initialize(name, threshold, dirs)
      super
      @mass_threshold = threshold
    end

    # rubocop:disable all
    def define
      desc "Analyze for code duplication in: #{dirs.join(", ")}"
      task name do
        require "flay"
        flay = Flay.new
        flay.mass_threshold = @mass_threshold
        files = Flay.filter_files Flay.expand_dirs_to_files dirs
        flay.process(*files)
        flay.report if verbose

        raise "Flay total too high! #{flay.total} > #{threshold}" if
        flay.total > threshold
      end
      self
    end
    # rubocop:enable all
  end

  CustomFlayTask.new(
    _name = :flay,
    _threshold = 10,
    _dirs = code_dirs
  )
rescue LoadError
  puts "Unable to load Flay rake task"
end
