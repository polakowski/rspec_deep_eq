require 'deep_eq/matcher'

module DeepEq
  def deep_eq(expected)
    Matcher.new(expected)
  end
end
