##
# @file type_checking.rb
# Check whether provided values are instances of a specified type.
#
# Provide validation for an extended set of types beyond those supported by JSON.
##
module Brine

  ##
  # Support asserting the type of values.
  ##
  module TypeChecking

    require 'rspec/expectations'
 
    ##
    # Define a registry of checks for types which can return a Matcher for registered types.
    ##
    class TypeChecks
      include RSpec::Matchers

      ##
      # Initialize an instance with default checks or those provided.
      #
      # @param [Hash<String, Matcher>] Provide a hash of Matchers by type, where the Matcher value will be
      #                                used as the Matcher for the specified type.
      #                                It is expected that no map will be provided and the default
      #                                mapping will therefore be used.
      ##
      def initialize(map={Object: be_a_kind_of(Hash),
                          String: be_a_kind_of(String),
                          Number: be_a_kind_of(Numeric),
                          Integer: be_a_kind_of(Integer),
                          Array: be_a_kind_of(Array),
                          DateTime: be_a_kind_of(Time),
                          Boolean: satisfy{|it| it == true || it == false } })
        @map = map
      end

      ##
      # Return the Matcher for the specified type or die if not present.
      #
      # @param type [Class] Specify the type whose Matcher should be returned.
      # @return [RSpec::Matcher] Return the Matcher registered for `type`.
      # @throw Exception Raise an exception if no Matcher exists for `type`.
      ##
      def for_type(type)
        @map[type.to_sym] || raise("Unsupported type #{type}")
      end

      ##
      # Register the provided matcher for the specified type.
      #
      # @param type [Class] Specify the type for which the Matcher will be registered.
      # @param[RSpec::Matcher] matcher Provide a matcher to verify that input is an instance of type.
      ##
      def register_matcher(type, matcher)
        @map[type.to_sym] = matcher
      end
    end

    ##
    # Expose the currently active TypeCheck instance as a property, instantiating as needed.
    ##
    def type_checks
      @type_check ||= TypeChecks.new
    end

    ##
    # Return the Matcher for the specified type.
    #
    # This is the primary interface for type_checking to the rest of the system,
    # and is the only one expected to be used during test execution.
    #
    # @param type [Class] Specify the type for which a Matcher should be returned.
    # @return [RSpec::Matcher] Return the Matcher currently registered for the type.
    # @throw Exception Raise an exception if no Matcher exists for `type`.
    ##
    def type_check_for(type)
      type_checks.for_type(type)
    end
  end

  ##
  # Mix the TypeChecking module functionality into the main Brine module.
  ##
  include TypeChecking
end

require 'brine/transforming'

##
# Assert that the selected value satisfies the specified type check.
#
# @param type [Object] Specify the key for the type checker to evaluate the selection.
##
Then('it is a valid {grave_param}') do |type|
  perform { selector.assert_that(type, binding) {|t| type_check_for(t) } }
end
