require 'brine/coercer'
require 'rspec/expectations'
require 'jsonpath'

# Selectors here are small wrappers around RSpec
# expectation behavior to encapsulate variations in
# some expecation associated behavior in classes.
class Selector
  include RSpec::Matchers
  attr_accessor :coercer

  def initialize(target, negated)
    @target = target
    @message = negated ? :to_not : :to
  end

  def filter_matcher(matcher)
    matcher
  end

  def assert_that(value)
    target, value = coercer.coerce(@target, value)
    matcher = filter_matcher(yield(value))
    expect(target).send(@message, matcher)
  end
end

class AnySelector < Selector
  def filter_matcher(matcher)
    include(matcher)
  end
end

class AllSelector < Selector
  def filter_matcher(matcher)
    all(matcher)
  end
end

#
# Module
#
module Selection
  include Coercion
  attr_reader :selector

  def use_selector(selector)
    selector.coercer = coercer
    @selector = selector
  end
end

#
# Steps
#
RESPONSE_ATTRIBUTES='(status|headers|body)'
Then(/^the value of `([^`]*)` is( not)? (.*)$/) do |value, negated, assertion|
  use_selector(Selector.new(value, (!negated.nil?)))
  step "it is #{assertion}"
end

def dig_from_response(attribute, path=nil, plural=false)
  root = response.send(attribute.to_sym)
  return root if !path
  JsonPath.new("$.#{path}").send(plural ? :on : :first, root)
end
