##
# @file selecting.rb
# Support selection of one or more values to be used by Brine (normally for assertion).
##
require 'brine/transforming.rb'

module Brine

  ##
  # Provide assorted means to select particular values out of objects/graphs.
  ##
  module Selecting

    require 'brine/coercing'
    require 'rspec/expectations'
    require 'jsonpath'

    ##
    # Allow selection of one or more values.
    # This Selector will test whether the targeted value itself satisfies the assertion.
    #
    # RSpec is used within this implementation to perform assertions.
    # The Selector ultimately perform this assertion by accepting an RSpec matcher
    # which it applied against the targeted value.
    ##
    class Selector
      include ParameterTransforming
      include RSpec::Matchers

      ##
      # [Coercer] Expose the Coercer that may modify values prior to performing assertions.
      ##
      attr_accessor :coercer

      ##
      # Construct a selector to perform assertions against a provided target.
      #
      # @param target [Object] Provide the value against which assertions will be performed.
      # @param negated [Boolean] Specify whether the assertions from this selector should be negated.
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
      # in which matchers are applied against the values.
      # The default implementation is a passthrough.
      #
      # @param matcher [RSpec::Matcher] Relay the matcher originally passed to #assert_that.
      # @return [RSpec::Matcher] Return the Matcher to use while performing the assertion.
      ##
      def filter_matcher(matcher)
        matcher
      end

      ##
      # Perform the provided assertion against the instance target.
      #
      # The values will be coerced prior to evaluation.
      #
      # @param value [Object] Specify the value/parameter against which the target will be compared.
      #                       In cases where no parameter is needed for comparison, this may be nil.
      # @param binding [Object] Provide the binding environment which will be used to expand any templates
      # @param negated [Boolean] Specify whether the assertion should be expected to _fail_, if false it should pass.
      # @param [Block] Define the logic  which will be passed a coerced copy of `value` and which should return an
      #                RSpec matcher which will be evaluated against the coerced target value.
      ##
      def assert_that(value, binding, negated=nil)
        # shim while moving negation to assertions.
        negated = @negated if negated.nil?
        target, value = coercer.coerce(expand(@target, binding), expand(value, binding))
        message = negated ? :to_not : :to
        matcher = filter_matcher(yield(value))
        expect(target).send(message, matcher)
      end

    end

    ##
    # Define a Selector which will test whether any of the children of the targeted value satisfy the assertion.
    ##
    class AnySelector < Selector
      def filter_matcher(matcher)
        include(matcher)
      end
    end

    ##
    # Define a Selector which will test whether all of the children of the targeted value satisfy the assertion.
    ##
    class AllSelector < Selector
      def filter_matcher(matcher)
        all(matcher)
      end
    end

    ##
    # Activate a Selector for the provided target.
    #
    # @param target [Object] Provide the value which the Selector should target.
    # @param negated [Boolean] Specify whether the assertions should be expected to fail (DEPRECATED).
    ##
    def select(target, negated=nil)
      use_selector(Selector.new(target, negated))
    end

    ##
    # Activate a Selector for any of the children of the provided target.
    #
    # @param target [Object] Provide the value which the Selector should target.
    # @param negated [Boolean] Specify whether the assertions should be expected to fail (DEPRECATED).
    ##
    def select_any(target, negated=nil)
      use_selector(AnySelector.new(target, negated))
    end

    ##
    # Activate a Selector for all of the children of the provided target.
    #
    # @param target [Object] Provide the value which the Selector should target.
    # @param negated [Boolean] Specify whether the assertions should be expected to fail (DEPRECATED).
    ##
    def select_all(target, negated=nil)
      use_selector(AllSelector.new(target, negated))
    end

    ##
    # Configure selector and make it the active Selector.
    #
    # @param selector [Selector] Provide the selector which will be activated.
    ##
    def use_selector(selector)
      selector.coercer = coercer
      @selector = selector
    end

    ##
    # Return the currently active Selector.
    #
    # @return [Selector] Return the Selector as set by #use_selector.
    ##
    def selector
      @selector
    end

    ##
    # Capture a path for which the value will be retrieved from a root.
    ##
    class Traversal

      ##
      # Return a traversal for the provided path.
      #
      # @param path [String] Define the JSONPath for the location of the value(s) to retrieve.
      # @param is_plural [Boolean] Specify whether a collection should be returned for possibly multiple values,
      #                            false if only a single value should be expected/returned.
      ##
      def initialize(path, is_plural)
        @path = path
        @message = is_plural ? :on : :first
      end

      ##
      # Return values out of the provided root based on the traversal definition.
      #
      # @param root [String] Provide the JSON structure from which the value will be retrieved.
      # @return [Object] Return the value or values (if is_plural) at the defined path or nil if none found.
      ##
      def visit(root)
        !@path ? root : JsonPath.new("$.#{@path}").send(@message, root)
      end
    end

    ##
    # Return a Traversal based on the provided arguments.
    #
    # This primarily exists as the exported interface to retrieve a Traversal instance.
    #
    # @param path [String] Define the JSONPath to which the traversal should descend.
    # @param is_plural [Object] Specify whether to produce a traversal for a collection of all matches:
    #                           nil will target only a single match, any non-nil value will target all matches.
    # @return [Traversal] Return a Traversal configured based on the provided arguments.
    ##
    def traversal(path, is_plural)
      Traversal.new(path, !is_plural.nil?)
    end
  end

  # Mix the Selecting module functionality into the main Brine module.
  include Selecting

end

##
# Retrieve the requested attribute from the current response.
#
# @param attribute [String] Specify the attribute to return from the response.
# @return [Object] Return the value of the attribute for the current response.
##
def response_attribute(attribute)
  response.send(attribute.to_sym)
end

##
# Extract assertion step text.
##
ParameterType(
  name: 'assertion',
  regexp: /.*[^:]/,
  transformer: -> (input) { input },
  use_for_snippets: false
)

##
# Extract the text for a standard HTTP method.
##
ParameterType(
  name: 'http_method',
  regexp: /(DELETE|GET|HEAD|OPTIONS|PATCH|POST|PUT)/,
  transformer: -> (input) { input }
)

##
# Indicate whether not is present.
##
ParameterType(
  name: 'maybe_not',
  regexp: /( not)?/,
  transformer: -> (input=nil) { !input.nil? }
)

##
# Extract the text for a supported response attribute.
##
ParameterType(
  name: 'response_attribute',
  regexp: /(status|headers|body)/,
  transformer: -> (input) { input }
)

# Messing with the parameters is due to cucumber expressions
# not working properly...that should be chased down.

##
# Produce a Traversal for one or all elements at the specified path.
##
ParameterType(
  name: 'traversal',
  regexp: /(?: child(ren)? `([^`]*)`)?/,
  transformer: -> (plural_or_path=nil, path=nil) {
    if path.nil?
      path=plural_or_path
      plural_or_path=nil
    end
    traversal(path, plural_or_path)
  }
)

##
# Select a directly provided value.
#
# @param value [Object] Provide the value for which the assertion will be evaluated.
# @param negated [Object] Indicate whether the assertion should be exected to fail.
# @param assertion [String] Provide the assertion step to evaluate.
##
Then('the value of {grave_param} is{maybe_not} {assertion}') do |value, negated, assertion|
  select(value, negated)
  # Stringify in case the assertion clause is a template.
  step "it is #{assertion}"
end

##
# Evaluate an assertion against a response attribute.
#
# @param attribute [String] Indicate from which response attribute the value will be selected.
# @param traversal [Traversal] Provide a Traversal to retrieve the value from the attribute.
# @param negated [Boolean] Specify whether the assertion should be expected to fail (DEPRECATED).
# @param assertion [Object] Provide the assertion step to evaluate.
##
Then('the value of the response {response_attribute}{traversal} is{maybe_not} {assertion}') do
  |attribute, traversal, negated, assertion|
  perform do
    select(traversal.visit(response_attribute(attribute)), negated)
    step "it is #{assertion}"
  end
end


##
# Evaluate an assertion against a response attribute and provide a docstring parameter.
#
# @param attribute [String] Indicate from which response attribute the value will be selected.
# @param traversal [Traversal] Provide a Traversal to retrieve the value from the attribute.
# @param negated [Boolean] Specify whether the assertion should be expected to fail (DEPRECATED).
# @param assertion [Object] Provide the assertion step to evaluate.
# @param multi [String] Pass a docstring parameter which will be forwarded to the assertion.
##
Then('the value of the response {response_attribute}{traversal} is{maybe_not} {assertion}:') do
  |attribute, traversal, negated, assertion, multi|
  perform do
    select(traversal.visit(response_attribute(attribute)), negated)
    step "it is #{assertion}:", multi
  end
end

##
# Evaluate an assertion against at least one matched value from the response attribute.
#
# @param attribute [String] Indicate from which response attribute the values will be selected.
# @param traversal [Traversal] Provide a Traversal to retrieve values from the attribute.
# @param negated [Boolean] Specify whether the assertion should be expected to fail (DEPRECATED).
# @param assertion [Object] Provide the assertion step to evaluate.
##
Then('the value of the response {response_attribute}{traversal} does{maybe_not} have any element that is {assertion}') do
  |attribute, traversal, negated, assertion|
  perform do
    select_any(traversal.visit(response_attribute(attribute)), negated)
    step "it is #{assertion}"
  end
end

##
# Evaluate an assertion against at least one matched value from the response attribute and provide a docstring parameter.
#
# @param attribute [String] Indicate from which response attribute the values will be selected.
# @param traversal [Traversal] Provide a Traversal to retrieve values from the attribute.
# @param negated [Boolean] Specify whether the assertion should be expected to fail (DEPRECATED).
# @param assertion [Object] Provide the assertion step to evaluate.
# @param multi [String] Pass a docstring parameter which will be forwarded to the assertion.
##
Then('the value of the response {response_attribute}{traversal} does{maybe_not} have any element that is {assertion}:') do
  |attribute, traversal, negated, assertion, multi|
  perform do
    select_any(traversal.visit(response_attribute(attribute)), negated)
    step "it is #{assertion}:", multi
  end
end

##
# Evaluate an assertion against ALL matched value from the response attribute.
#
# @param attribute [String] Indicate from which response attribute the values will be selected.
# @param traversal [Traversal] Provide a Traversal to retrieve values from the attribute.
# @param assertion [Object] Provide the assertion step to evaluate.
##
Then('the value of the response {response_attribute}{traversal} has elements which are all {assertion}') do
  |attribute, traversal, assertion|
  perform do
    select_all(traversal.visit(response_attribute(attribute)), false)
    step "it is #{assertion}"
  end
end

##
# Evaluate an assertion against ALL matched value from the response attribute and provide a docstring argument.
#
# @param attribute [String] Indicate from which response attribute the values will be selected.
# @param traversal [Traversal] Provide a Traversal to retrieve values from the attribute.
# @param assertion [Object] Provide the assertion step to evaluate.
# @param multi [String] Pass a docstring parameter which will be forwarded to the assertion.
##
Then('the value of the response {response_attribute}{traversal} has elements which are all {assertion}:') do
  |attribute, traversal, assertion, multi|
  perform do
    select_all(traversal.visit(response_attribute(attribute)), false)
    step "it is #{assertion}:", multi.to_json
  end
end
