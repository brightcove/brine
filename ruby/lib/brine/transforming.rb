##
# @file  transforming.rb
# Argument Parameter transforming for Brine.
##
module Brine

  ##
  #
  # A module that converts provided paramters to richer types.
  #
  # This eases use of types beyond the Cucumber-provided simple strings.
  ##
  module ParameterTransforming

    ##
    # A class which will transform supported input.
    #
    # This implementation is designed around instances being
    # defined with patterns which define whether they should handle
    # provided input, and procs which should do the transformation
    # (when the patterns match).
    ##
    class Transformer
      attr_reader :type

      ##
      # Return a new Transformer instance configured as specified.
      #
      # @param [String] type The name of the type produced by this transformer.
      #                      This will be used for upcoming explicit type conversion.
      # @param [Regexp] pattern A pattern which input should match for this Transformer to function.
      # @param [Proc] xfunk The function which will be passed string input and will return
      #                     the output type of this Transformer.
      ##
      def initialize(type, pattern, &xfunc)
        @type = type
        @pattern = pattern
        @xfunc = xfunc
      end

      ##
      # Whether this instance should attempt to transform the input.
      #
      # @param [String] input The String input as provided by Cucumber.
      # @return [Boolean] Whether this#transform should be called for input.
      ##
      def can_handle?(input)
        input =~ @pattern
      end

      ##
      # Transform the provided input.
      #
      # @param [String] input The String input as provided by Cucumber.
      # @return [Object] The transformed input into the appropriate type.
      ##
      def transform(input)
        STDERR.puts("Handling #{input} as #{@type}") if ENV['BRINE_LOG_TRANSFORMS']
        @xfunc.call(input)
      end
    end

    # Constants used for DateTime transformation.
    DATE='\d{4}-\d{2}-\d{2}'
    TIME='\d{2}:\d{2}:\d{2}'
    MILLIS='(?:\.\d{3})?'
    TZ='(?:Z|(?:[+-]\d{2}:\d{2}))'

    ##
    # The chain of Transformers which will be used to convert parameters.
    #
    # In the default implicit mode the list will be iterated over in sequence
    # and the first Transformer which can handle the input will be used.
    # The order of the Transformers is therefore significant: higher priority
    # or more specific Transfomers should be earlier in the list than those
    # that are lower priority or can handle a superset of supported input
    # relative to those previous.
    #
    # This exposed for direct list manipulation as an advanced customization point.
    ##
    def parameter_transformers
      @parameter_transformers ||= [

        # These will be deprecated in preference for explicit type specification.
        Transformer.new('Double Quoted', /\A".*"\z/) {|input|
          input[1..-2] },
        Transformer.new('Single Quoted', /\A'.*'\z/) {|input|
          input[1..-2] },

        # Whitespace removal transforms
        # Handle stripping leading and trailing whitespace.
        # These are split out from the transforms to consolidate the behavior.
        # They call transform on the stripped value so that subsequent transforms no longer
        # have to deal with such whitespace.
        #
        # Note that these need to deal with multiline string arguments which require
        # the multiline flag and \A/\z anchors to properly operate on the full string rather than
        # being line oriented. The calls to +#strip+ are also not likely to properly clean up
        # multiline strings but is just meant as a (potentially ineffective) optimization over
        # recursive calls and capturing.
        Transformer.new('Trailing Whitespace', /\A\s+.*\z/) {|input|
          transformed_parameter(input.strip) },
        Transformer.new('Leading Whitespace', /\A.*\s+\z/m) {|input|
          transformed_parameter(input.strip) },

        # Template Expansion
        Transformer.new('Template', /.*{{.*}}.*/) {|input|
          as_template(input) },

        # Scalars
        Transformer.new('Integer', /\A-?\d+\z/) {|input|
          input.to_i },
        Transformer.new('Boolean', /\Atrue|false\z/) {|input|
          input.to_s == "true" },
        # This presently does not support flags after the closing slash, support for these should be added as needed
        Transformer.new('Regex', /\A\/.*\/\z/) {|input|
          Regexp.new(input[1..-2]) },
        Transformer.new('DateTime', /^#{DATE}T#{TIME}#{MILLIS}#{TZ}$/) {|input|
          Time.parse(input) },

        # Structures
        Transformer.new('Array', /\A\[.*\]\z/m) {|input| JSON.parse(input) },
        Transformer.new('Object', /\A{.*}\z$/m) {|input| JSON.parse(input) },

        # String sentinel...this is last to act as a catch-all.
        Transformer.new('String', /.*/) {|input| input },
      ]
    end

    ##
    # Transform the provided input using #parameter_transformers.
    #
    # @param [String] input The String input as provided by Cucumber.
    # @return [Object] The input converted by the handling Transformer.
    ##
    def transformed_parameter(input)
      parameter_transformers.find {|it| it.can_handle? input }
        .transform(input)
    end

    ##
    # Expand val if needed and transform the result.
    #
    # If val is not `expand`able it will be returned as is.
    #
    # @param [Object] val The value to potentially expand.
    # @return The expanded value of val.
    ##
    def expand(val)
      if val.respond_to? :expand
        transformed_parameter(val.expand)
      else
        val
      end
    end

  end

  ##
  # Mix the ParameterTransforming module functionality into the main Brine module.
  ##
  include ParameterTransforming
end

##
# Configure Cucumber to use these transformers.
##
Transform /.*/ do |input|
  transformed_parameter(input)
end
