##
# @file coering.rb
# Coerce types to support assertions.
##

module Brine

  ##
  # Provide type coercion.
  ##
  module Coercing

    ##
    # Coerces the types of provided objects to support assertion evaluation.
    #
    # Coercion is used to support handling richer data types in Brine without
    # introducing noisy type information to the language.
    # Transformation code can be used to convert input provided directly
    # to a Brine step, however data extracted from JSON will by default be
    # limited to the small amount of JSON supported data types. As normally
    # the data extracted from JSON will only be directly present on one side
    # of the assertion (most likely the left), the simpler JSON data types can
    # be coerced to a richer type based on the right hand side.
    #
    # A standard example (and one which is supported in this file) is date/time
    # values. When testing an API that returns such values it is likely desirable to
    # perform assertions with proper date/time semantics, and the coercer allows
    # such assertions against a value retrieved out of a JSON structure.
    #
    # The combination of transforming of ParameterType inputs and the Coercer can
    # also effectively allow for user defined types to seemlessly exist within the
    # Brine tests.
    #
    # Implementation (Most of the non-implementation info should later be moved).
    # ---
    # Internally the Coercer is a wrapper around a map of coercion functions
    # where the keys are the pairs of classes for the operands and the
    # values are the functions which accept a pair of instances (ostensibly) of the
    # classes and return a pair of transformed values. The default coercion function
    # returns the inputs unmodified (a nop), so any pair of classes which does not
    # have a key will pass through unchanged.
    #
    # Note that this relies solely on the hash lookup and does not attempt any kind
    # of inheritance lookup or similar. The current thinking is that there should be
    # few expected types and lineage could be covered through explicit keys so the
    # simple, dumb approach is likely sufficient.
    ##
    class Coercer

      ##
      # Instantiate a new Coercer.
      #
      # Initialize the standard map of coercion functions.
      ##
      def initialize
        @map = Hash.new(->(lhs, rhs){[lhs, rhs]})
        @map[[String, Time]] = ->(lhs, rhs){[Time.parse(lhs), rhs]}
      end

      ##
      # Coerce the provided inputs as needed.
      #
      # Looks up and invokes the associated coercion function.
      #
      # @param first [Object] Provide the first operand.
      # @param second [Object] Provide the second operand.
      # @return [Array] Return the coerced [first, second] values.
      ##
      def coerce(first, second)
        @map[[first.class, second.class]].call(first, second)
      end

    end

    ##
    # Expose a Coercer as a property.
    #
    # A Coercer will be instantiated as needed on first access.
    #
    # @return [Coercer] Return the object which will be used to handle coercions.
    ##
    def coercer
      @coercer ||= Coercer.new
    end

  end

  ##
  # Mix the Coercing module functionality into the main Brine module.
  ##
  include Coercing
end
