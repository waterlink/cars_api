module CarsServer
  # LimitParser understands valid limit query parameter format
  class LimitParser
    DEFAULT_LIMIT = 10
    MAX_LIMIT = 20

    def initialize(
      params,
      default_limit: DEFAULT_LIMIT,
      max_limit: MAX_LIMIT
    )
      @params = params
      @default_limit = default_limit
      @max_limit = max_limit
    end

    def limit
      return max_limit if too_large?
      parsed_limit
    end

    private

    attr_reader :params, :default_limit, :max_limit

    def too_large?
      parsed_limit > max_limit
    end

    def parsed_limit
      @_parsed_limit ||= parse_limit
    end

    def parse_limit
      (params[:limit] || default_limit).to_i
    end
  end
end
