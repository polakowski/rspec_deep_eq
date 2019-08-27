require_relative './deep_equal_checker'

module DeepEq
  class Matcher
    def initialize(expected)
      @expected = expected
      @errors = []
    end

    def matches?(current)
      @current = current

      perform_deep_equal_check

      errors.empty?
    end

    def failure_message
      message = [
        'Expected',
        current.inspect,
        "\nto be deep equal to",
        expected.inspect,
        '',
        "\nFollowing errors found:"
      ]

      message.concat(errors).push("\r").join("\n")
    end

    def failure_message_when_negated
      message = [
        'Expected',
        current.inspect,
        "\nnot to be deep equal to",
        expected.inspect,
        "\nBut equal values found."
      ].join("\n") + "\n"
    end

    def add_error(error)
      errors.push error
    end

    private

    attr_reader :errors, :current, :expected

    def perform_deep_equal_check
      DeepEqualChecker.new(
        current: current,
        expected: expected,
        location: 'value',
        matcher_object: self
      ).perform
    end
  end
end
