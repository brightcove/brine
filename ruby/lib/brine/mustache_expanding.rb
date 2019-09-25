##
# @file mustache_expanding.rb
# Support expanding Mustache templates with a provided binding.
##
module Brine

  ##
  # Provide a binding environment and template expansion that can use such an environment.
  ##
  module MustacheExpanding
    require 'mustache'

    ##
    # Furnish a mutable hash to serve as a binding environment.
    #
    # @return [Hash<String, Object>] Return the active binding environment.
    ##
    def binding
      @binding ||= {}
    end

    ##
    # Assign `value' to `key' within binding,
    #
    # @param key [String] Specify the key in the binding to which `value` will be assigned.
    # @param value [Object] Specify the value to assign to ``key` within the binding.
    ##
    def bind(key, value)
      STDERR.puts "Assigning #{value} to #{key}" if ENV['BRINE_LOG_BINDING']
      binding[key] = value
    end

    ##
    # Provide an expandable Mustache template using binding environment.
    #
    # This exists to support latent expansion and template retrieval.
    ##
    class BrineTemplate < Mustache

      ##
      # Instantiate a BrineTemplate.
      #
      # @param tmpl [String] Define the string content of the template.
      ##
      def initialize(tmpl)
        @template = tmpl
      end

      ##
      # Expand the template using the provided bindings.
      #
      # @param binding [Hash] Provide bound values to use within the template.
      # @return [String] Return the contents of this template applied against `binding`.
      ##
      def expand(binding)
        begin
          context.push(binding)
          render
        ensure
          context.pop
        end
      end

      ##
      # Stringify as template contents.
      #
      # This supports cases such as dynamic steps where a string is expected
      # but the template should not yet be expanded.
      ##
      def to_s
        @template
      end
    end

    ##
    # Allow retrieval of BrineTemplates for provided template content.
    #
    # @param str [String] Define the string contents for the returned template.
    # @return [BrineTemplate] Return a BrineTemplate with the provided content.
    ##
    def as_template(str)
      BrineTemplate.new(str)
    end
  end

  ##
  # Mix the MustacheExpanding module functionality into the main Brine module.
  ##
  include MustacheExpanding
end

##
# Assign the provided value to the specified identifier.
#
# @param name [Object] Specify the identifier to which the value will be bound.
# @param value [Object} Provide the value to bind to the identifier.
##
When('{grave_param} is assigned {grave_param}') do |name, value|
  perform { bind(expand(name, binding), value) }
end

##
# Assign a random string (UUID) to the specified identifier.
#
# @param name [Object] Specify the identifier to which a random string will be bound.
##
When('{grave_param} is assigned a random string') do |name|
  perform { bind(expand(name, binding), SecureRandom.uuid) }
end

##
# Assign a current timestamp to the specified identifier.
#
# @param name [Object] Specify the identifier to which the timestamp will be bound.
##
When('{grave_param} is assigned a timestamp') do |name|
  perform { bind(expand(name, binding), DateTime.now) }
end
