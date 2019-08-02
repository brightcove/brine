##
# @file mustache_expanding.rb
# Support for expanding Mustache templates with a defined binding.
##
module Brine

  ##
  # Provides a binding environment and template expansion that uses that environment.
  ##
  module MustacheExpanding
    require 'mustache'

    ##
    # Mutable hash which serves as binding environment.
    #
    # @return [Hash<String, Object>] The active binding environment.
    ##
    def binding
      @binding ||= {}
    end

    ##
    # Assign `value' to `key' within binding,
    #
    # @param [String] key The key in the binding to which `value` will be assigned.
    # @param [Object] value The value to assign to ``key` within the binding.
    ##
    def bind(key, value)
      STDERR.puts "Assigning #{value} to #{key}" if ENV['BRINE_LOG_BINDING']
      binding[key] = value
    end

    ##
    # Expanded Mustache template using binding environment.
    #
    # This exists to support latent expansion and template retrieval.
    #
    # @param [String] template Template content to expand with binding.
    # @return [String] The contents of `template` with any expansions done using `binding`.
    ##
    class BrineTemplate < Mustache

      ##
      # Instantiate a Brine template.
      #
      # @param tmpl [String] The string content of the template.
      # @param binding [Hash] A reference to the (mutable) binding.
      ##
      def initialize(tmpl, binding)
        @template = tmpl
        @binding = binding
      end

      ##
      # Expand the template using the current bindings.
      ##
      def expand
        begin
          context.push(@binding)
          render
        ensure
          context.pop
        end
      end

      ##
      # Stringify as template contents.
      #
      # This supports cases such as dynamic steps
      # where a string is expected but the template should not yet
      # be expanded.
      ##
      def to_s
        @template
      end
    end

    def as_template(str)
      BrineTemplate.new(str, binding)
    end
  end

  ##
  # Include the MustacheExpanding module functionality into the main Brine module.
  ##
  include MustacheExpanding
end
