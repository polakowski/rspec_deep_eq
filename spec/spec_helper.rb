require 'rspec'
require 'deep_eq'
require 'pry-rails'
require 'deep_eq'

require_relative 'mocks/fake_record'
require_relative 'mocks/matcher'

module RSpec::Matchers
  include DeepEq
end
