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
    # Mustache in...no Mustache out.
    #
    # @param [String] template Template content to expand with binding.
    # @return [String] The contents of `template` with any expansions done using `binding`.
    ##
    def shave_value(template)
      Mustache.render(template, binding)
    end

  end

  ##
  # Include the MustacheExpanding module functionality into the main Brine module.
  ##
  include MustacheExpanding
end
