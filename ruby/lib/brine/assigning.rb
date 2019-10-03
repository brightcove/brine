##
# @file assigning.rb
# Provide some assignment steps.
##

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

