require 'mustache'

# Provides a binding environment and template expansion functions that use that
# environment
module MustacheBinder

  # getter for mutable hash which serves as binding environment
  def binding
    @binding ||= {}
  end

  # assign `value' to `key' within binding
  # defined in a method to allow observability/interception
  def bind(key, value)
    puts "Assigning #{value} to #{key}" if ENV['BRINE_LOG_BINDING']
    binding[key] = value
  end

  # return value as expanded Mustache template using binding environment
  # Mustache in...no Mustache out
  def shave_value(val)
    Mustache.render(val, binding)
  end

end
