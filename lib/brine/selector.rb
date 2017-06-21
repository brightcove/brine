require 'brine/coercer'
require 'rspec/expectations'

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

  def assert_that(value)
    target, value = coercer.coerce(@target, value)
    matcher = yield(value)
    expect(target).send(@message, matcher)
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
Then(/^the value of `([^`]*)` is( not)? (.*)$/) do |value, negated, assertion|
  use_selector(Selector.new(value, (!negated.nil?)))
  step "it is #{assertion}"
end

RESPONSE_ATTRIBUTES='(status|headers|body)'
Then(/^the value of the response #{RESPONSE_ATTRIBUTES} is( not)? (.*)(?<!:)$/) do
  |attribute, negated, assertion|
  use_selector(Selector.new(dig_from_response(attribute), (!negated.nil?)))
  step "it is #{assertion}"
end

Then(/^the value of the response #{RESPONSE_ATTRIBUTES} is( not)? (.*)(?<=:)$/) do
  |attribute, negated, assertion, multi|
  use_selector(Selector.new(dig_from_response(attribute), (!negated.nil?)))
  step "it is #{assertion}", multi.to_json
end

Then(/^the value of the response #{RESPONSE_ATTRIBUTES} child `([^`]*)` is( not)? (.*)$/) do
  |attribute, path, negated, assertion|
  use_selector(Selector.new(dig_from_response(attribute, path), (!negated.nil?)))
  step "it is #{assertion}"
end

def dig_from_response(attribute, path=nil)
  root = response.send(attribute.to_sym)
  return root if !path
  root.dig(*(path.split('.').map{|it| Integer(it) rescue it}))
end
