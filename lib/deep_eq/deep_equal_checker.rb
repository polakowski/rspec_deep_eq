module DeepEq
  class DeepEqualChecker
    def initialize(current:, expected:, location:, matcher_object:)
      @current = current
      @expected = expected
      @location = location
      @matcher_object = matcher_object
    end

    def perform
      case expected
      when Array
        return unless current_ensure_array
        return unless current_ensure_count

        expected.count.times do |index|
          DeepEqualChecker.new(
            current: current[index],
            expected: expected[index],
            location: location + "[#{index}]",
            matcher_object: matcher_object
          ).perform
        end
      when Hash
        return unless current_ensure_hash
        return unless current_ensure_keys

        expected.keys.each do |key|
          d = DeepEqualChecker.new(
            current: current[key],
            expected: expected[key],
            location: location + "[#{key.inspect}]",
            matcher_object: matcher_object
          ).perform
        end
      else
        compare_values
      end
    end

    private

    def compare_values
      return if current == expected

      add_error "#{location} is invalid (expected #{expected.inspect}, got #{current.inspect})"
    end

    def add_error(error)
      matcher_object.add_error error
      false
    end

    def current_ensure_hash
      return true if current.is_a? Hash

      add_type_mismatch_error('Hash')
    end

    def current_ensure_array
      return true if current.is_a? Array

      add_type_mismatch_error('Array')
    end

    def current_ensure_count
      return true if current.count === expected.count

      add_error "#{location} is expected to have length #{expected.count}, but has #{current.count}"
    end

    def current_ensure_keys
      bad_keys = current.keys.reject { |key| expected.keys.include? key }

      return true if bad_keys.empty?

      add_error "#{location} is expected to not contain keys: #{bad_keys.map(&:inspect).join(', ')}"
    end

    def add_type_mismatch_error(expected_class)
      add_error "#{location} is expected to be #{expected_class}, but #{current.class} found"
    end

    attr_reader :current, :expected, :location, :matcher_object
  end
end




# module DeepEql
#   module Matchers
#
#     def deep_eql(expected)
#       DeepEql.new(expected)
#     end
#
#     class DeepEql
#
#       def initialize(expectation)
#         @expectation = expectation
#       end
#
#       def matches?(target)
#         result = true
#         @target = target
#         case @expectation
#         when Hash
#           result &&= @target.is_a?(Hash) && @target.keys.count == @expectation.keys.count
#           @expectation.keys.each do |key|
#             result &&= @target.has_key?(key) &&
#             DeepEql.new(@expectation[key]).matches?(@target[key])
#           end
#         when Array
#           result &&= @target.is_a?(Array) && @target.count == @expectation.count
#           @expectation.each_index do |index|
#             result &&= DeepEql.new(@expectation[index]).matches?(@target[index])
#           end
#         else
#           result &&= @target == @expectation
#         end
#         result
#       end
#
#       def failure_message_for_should
#         "expected #{@target.inspect} to be deep_eql with #{@expectation.inspect}"
#       end
#
#       def failure_message_for_should_not
#         "expected #{@target.inspect} not to be in deep_eql with #{@expectation.inspect}"
#       end
#     end
#
#   end
# end
