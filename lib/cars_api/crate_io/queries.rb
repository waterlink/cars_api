require "cars_api/crate_io"

module CarsApi
  module CrateIO
    # Queries knows structure of queries for CarStore in crate.io
    class Queries
      RATIOS = {
        kms: "/1000.0",
        miles: "/1609.34"
      }.freeze

      def initialize(table)
        @table = table
      end

      def init_table
        <<-EOF
          create table if not exists #{table} (
            id string primary key,
            description string,
            location geo_point
          ) clustered by (id) into 3 shards
        EOF
      end

      def get_closest(units)
        distance = "distance(location, \$1) #{RATIOS[units]} as distance"

        <<-EOF
          select id, description, location, #{distance}
          from #{table}
          order by distance
          limit \$2
        EOF
      end

      def save
        <<-EOF
          insert into #{table} (id, description, location)
          values(\$1, \$2, \$3)
        EOF
      end

      def clear
        "delete from #{table}"
      end

      def all
        "select description, location from #{table}"
      end

      private

      attr_reader :table
    end
  end
end
