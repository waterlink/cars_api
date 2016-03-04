module CarsApi
  # Result represents a value with possible context of concrete failure value
  # (usually, error message)
  module Result
    # ResultProtocol represents an indicator of something being a Result
    module ResultProtocol
    end

    def self.from(value, &blk)
      From::OK.call(value, &blk)
    end

    def self.from_error(message, &blk)
      From::ERROR.call(message, &blk)
    end

    def self.ok(value)
      Ok[value]
    end

    def self.error(message)
      Error[message]
    end

    # From understands conversion of different values to Result
    class From
      def initialize(key, other_key)
        @key = key
        @other_key = other_key
      end

      def call(value)
        return Result.public_send(other_key, yield) if value.is_a?(NilClass)
        Result.public_send(key, value)
      end

      private

      attr_reader :key, :other_key

      OK = new(:ok, :error)
      ERROR = new(:error, :ok)
    end

    # OkStruct is a pure value object for Result in successful state
    OkStruct = Struct.new(:unwrap!)

    # Ok understands successful state of Result
    class Ok < OkStruct
      include ResultProtocol

      def when_ok
        Result.ok(yield(unwrap!))
      end

      def when_error
        self
      end

      def join
        return self unless unwrap!.is_a?(ResultProtocol)
        unwrap!
      end
    end

    # ErrorStruct is a pure value object for failed state of Result
    ErrorStruct = Struct.new(:message)

    # Error understands failed state of Result
    # suppress :reek:PrimaDonnaMethod
    class Error < ErrorStruct
      include ResultProtocol

      def when_ok
        self
      end

      def when_error
        Result.ok(yield(message))
      end

      def join
        self
      end

      def unwrap!
        raise(
          ArgumentError,
          "Error(#{message.inspect}) is not Ok."
        )
      end
    end
  end
end
