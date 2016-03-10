require "cars_util"

module CarsUtil
  # Equality knows when two objects are equal
  module Equality
    def def_equals(fields, file = __FILE__, line = __LINE__)
      class_eval <<-ruby_eval, file, line + 1
        def ==(other)
          return false unless other.is_a?(self.class)
          #{Equality.conditions_for(fields)}
        end
      ruby_eval
    end

    def self.conditions_for(fields)
      fields
        .map { |name| "#{name} == other.#{name}" }
        .join(" && ")
    end
  end
end
