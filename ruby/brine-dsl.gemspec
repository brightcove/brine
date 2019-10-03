# -*- encoding: utf-8 -*-
raise 'VERSION must be specified in environment' unless ENV['VERSION']
Gem::Specification.new do |s|
  s.name         = 'brine-dsl'
  s.version      = ENV['VERSION'][1..-1]
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Matt Whipple"]
  s.email        = ["mwhipple@brightcove.com"]
  s.license      = 'MIT'
  s.homepage     = "http://github.com/brightcove/brine"
  s.summary      = "Cucumber@REST in Brine"
  s.description  = "Cucumber@REST in Brine"

  s.required_ruby_version = '>= 2.3.0'

  s.add_runtime_dependency     'cucumber',            '~> 3.1'
  s.add_runtime_dependency     'mustache',            '~> 1.0'
  s.add_runtime_dependency     'oauth2',              '~> 1.4'
  s.add_runtime_dependency     'rspec',               '~> 3.7'
  s.add_runtime_dependency     'jsonpath',            '~> 0.8'
  s.add_runtime_dependency     'faraday',             '~> 0.12'
  s.add_runtime_dependency     'faraday_middleware',  '~> 0.12'

  s.add_development_dependency 'rake',                '~> 12.3'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
end
