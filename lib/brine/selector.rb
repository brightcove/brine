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
Then(/^the value of `([^`]*)` is( not)? (.*)$/) do |value, negated, assertion|
  use_selector(Selector.new(value, (!negated.nil?)))
  step "it is #{assertion}"
end

RESPONSE_ATTRIBUTES='(status|headers|body)'
Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? is( not)? (.*)(?<!:)$/) do
  |attribute, plural, path, negated, assertion|
  use_selector(Selector.new(dig_from_response(attribute, path, !plural.nil?), (!negated.nil?)))
  step "it is #{assertion}"
end

Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? is( not)? (.*)(?<=:)$/) do
  |attribute, plural, path, negated, assertion, multi|
  use_selector(Selector.new(dig_from_response(attribute, path, !plural.nil?), (!negated.nil?)))
  step "it is #{assertion}", multi.to_json
end

Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? does( not)? have any element that is (.*)(?<!:)$/) do
  |attribute, plural, path, negated, assertion|
  use_selector(AnySelector.new(dig_from_response(attribute, path, !plural.nil?), (!negated.nil?)))
  step "it is #{assertion}"
end

Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? does( not)? have any element that is (.*)(?<=:)$/) do
  |attribute, plural, path, negated, assertion, multi|
  use_selector(AnySelector.new(dig_from_response(attribute, path, !plural.nil?), (!negated.nil?)))
  step "it is #{assertion}", multi.to_json
end

#Would be negated with `not all' which would be equivalent to any(not ) but that's not readily supported
Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? has elements which are all (.*)(?<!:)$/) do
  |attribute, plural, path, assertion|
  use_selector(AllSelector.new(dig_from_response(attribute, path, !plural.nil?), false))
  step "it is #{assertion}"
end

Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? has elements which are all (.*)(?<=:)$/) do
  |attribute, plural, path, assertion, multi|
  use_selector(AllSelector.new(dig_from_response(attribute, path, !plural.nil?), false))
  step "it is #{assertion}", multi.to_json
end

def dig_from_response(attribute, path=nil, plural=false)
  root = response.send(attribute.to_sym)
  return root if !path
  JsonPath.new("$.#{path}").send(plural ? :on : :first, root)
end
