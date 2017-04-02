# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'mustache_binder'

Gem::Specification.new do |s|
  s.name         = 'brine'
  s.version      = '0.1.0'
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Matt Whipple"]
  s.email        = ["mwhipple@brightcove.com"]
  s.homepage     = "http://github.com/brightcove/brine"
  s.summary      = "Cucumber@REST in Brine"
  s.description  = "Cucumber@REST in Brine"

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency   'mustache'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
end
