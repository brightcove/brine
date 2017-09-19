# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name         = 'brine'
  s.version      = '0.3.3'
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Matt Whipple"]
  s.email        = ["mwhipple@brightcove.com"]
  s.license      = 'Apache 2.0'
  s.homepage     = "http://github.com/brightcove/brine"
  s.summary      = "Cucumber@REST in Brine"
  s.description  = "Cucumber@REST in Brine"

  s.required_ruby_version = '>= 2.3.0'

  s.add_runtime_dependency   'cucumber'
  s.add_runtime_dependency   'mustache'
  s.add_runtime_dependency   'oauth2'
  s.add_runtime_dependency   'rspec'
  s.add_runtime_dependency   'jsonpath'
  s.add_runtime_dependency   'faraday'
  s.add_runtime_dependency   'faraday_middleware'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-cucumber'
  s.add_development_dependency 'asciidoctor'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
end
