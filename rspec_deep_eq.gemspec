require_relative 'lib/deep_eq/version'

Gem::Specification.new do |s|
  s.name        = 'rspec_deep_eq'
  s.version     = DeepEq::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['polakowski']
  s.email       = ['marek.polakowski@gmail.com']
  s.homepage    = 'http://github.com/polakowski/rspec_deep_eq'
  s.summary     = 'RSpec deep_eq matcher'
  s.description = s.summary

  s.files         = Dir.glob('lib/**/*') + %w(README.md)
  s.test_files    = Dir.glob('spec/**/*')
  s.require_paths = ['lib']

  s.add_dependency 'rspec', '>= 2.0.0'

  s.add_development_dependency('guard-rspec')
  s.add_development_dependency('pry-rails')
end
