require 'mustache'

# Provides a binding environment and template expansion functions that use that
# environment
module MustacheBinder

  # getter for mutable hash which serves as binding environment
  def binding
    @binding ||= {}
  end

  # return value as expanded Mustache template using binding environment
  # Mustache in...no Mustache out
  def shave_value(val)
    Mustache.render(val, binding)
  end

end
