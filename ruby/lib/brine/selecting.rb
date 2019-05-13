##
# @file selecting.rb
# Selection of one or more values to be used by Brine (normally for assertion).
##

module Brine

  ##
  # A module providing assorted means to select particular values out of objects/graphs. 
  ##
  module Selecting

    require 'brine/coercing'
    require 'rspec/expectations'
    require 'jsonpath'

    ##
    # An object responsible for selecting one or more values.
    # This Selector will test whether the targeted value itself satisfies the assertion.
    #
    # RSpec is used within this implementation to perform assertions.
    # The Selector ultimately perform this assertion by accepting an RSpec matcher
    # which it applied against the targeted value.
    ##
    class Selector
      include RSpec::Matchers

      ##
      # [Coercer] The Coercer that may modify values prior to performing assertions.
      ##
      attr_accessor :coercer

      ##
      # Construct a selector to perform assertions against a provided target.
      #
      # @param [Object] taret The value against which assertions will be performed.
      # @param [Boolean] negated Whether the assertions from this selector should be negated.
      #                          This is deprecated and should instead be passed to #assert_that.
      ##
      def initialize(target, negated=false)
        @target = target
	@negated = negated
      end

      ##
      # Optionally perform some modification to the RSpec matcher prior to assertion.
      #
      # This is designed to allow subclassess to be able to modify the way
      # in which matchers are applied against the values. This method is a pass-through in this class.
      #
      # @param [RSpec::Matcher] matcher The matcher originally passed to #assert_that.
      # @return [RSpec::Matcher] The Matcher to be used while performing the assertion.
      ##
      def filter_matcher(matcher)
        matcher
      end

      ##
      # Perform the provided assertion against the instance target.
      #
      # The values will be coerced prior to evaluation.
      #
      # @param [Object] value The value/parameter against which the target will be compared.
      #                       In cases where no parameter is needed for comparison, this may be nil.
      # @param [Boolean] negated If true the assertion should be expected to _fail_, otherwise it should pass.
      # @param [Block] A block which will be passed a coerced copy of `value` and which should return an
      #                RSpec matcher which will be evaluated against the coerced target value.
      ##
      def assert_that(value, negated=nil)
        # shim while moving negation to assertions.
        negated = @negated if negated.nil?
        target, value = coercer.coerce(@target, value)
        message = negated ? :to_not : :to
        matcher = filter_matcher(yield(value))
        expect(target).send(message, matcher)
      end

    end

    ##
    # A Selector which will test whether any of the children of the targeted value satisfy the assertion.
    ##
    class AnySelector < Selector
      def filter_matcher(matcher)
        include(matcher)
      end
    end

    ##
    # A Selector which will test whether all of the children of the targeted value satisfy the assertion.
    ##
    class AllSelector < Selector
      def filter_matcher(matcher)
        all(matcher)
      end
    end

    ##
    # Activate a Selector for the provided target.
    #
    # @param [Object] target The value which the Selector should target.
    # @param [Boolean] negated DEPRECATED If true the assertions should be expected to fail.
    ##
    def select(target, negated=nil)
      use_selector(Selector.new(target, negated))
    end

    ##
    # Activate a Selector for any of the children of the provided target.
    #
    # @param [Object] target The value which the Selector should target.
    # @param [Boolean] negated DEPRECATED If true the assertions should be expected to fail.
    ##
    def select_any(target, negated=nil)
      use_selector(AnySelector.new(target, negated))
    end

    ##
    # Activate a Selector for all of the children of the provided target.
    #
    # @param [Object] target The value which the Selector should target.
    # @param [Boolean] negated DEPRECATED If true the assertions should be expected to fail.
    ##
    def select_all(target, negated=nil)
      use_selector(AllSelector.new(target, negated))
    end

    ##
    # Configure selector and make it the active Selector.
    #
    # @param [Selector] selector The selector which will be activated.
    ##
    def use_selector(selector)
      selector.coercer = coercer
      @selector = selector
    end

    ##
    # The currently active Selector.
    #
    # @return The Selector as set by #use_selector
    ##
    def selector
      @selector
    end

  end

  # Mix the Selecting module functionality into the main Brine module.
  include Selecting
end

#
# Steps
#
RESPONSE_ATTRIBUTES='(status|headers|body)'
Then(/^the value of `([^`]*)` is( not)? (.*)$/) do |value, negated, assertion|
  select(value, (!negated.nil?))
  step "it is #{assertion}"
end

def dig_from_response(attribute, path=nil, plural=false)
  root = response.send(attribute.to_sym)
  return root if !path
  JsonPath.new("$.#{path}").send(plural ? :on : :first, root)
end
