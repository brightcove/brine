##
# @file assignment.rb
# Assignment related steps.
##
response_attribute='(status|headers|body)'
grave_param='`([^`]*)`'
traversal='(?: child(ren)? `([^`]*)`)?'

##
# Assign the provided parameter.
#
# @param name - The identifier to which the value will be bound.
# @param value - The value to bind to the identifier.
##
When(/^#{grave_param} is assigned #{grave_param}$/) do |name, value|
  perform { bind(name, value) }
end

##
# Assign a random string (UUID).
#
# @param name - The identifier to which a random string will be bound.
##
When(/^#{grave_param} is assigned a random string$/) do |name|
  perform { bind(name, SecureRandom.uuid) }
end

##
# Assign a current timestamp.
#
# @param name - The identifier to which the current timestamp will be bound.
##
When(/^#{grave_param} is assigned a timestamp$/) do |name|
  perform { bind(name, DateTime.now) }
end

##
# Assign a value extracted from a response attribute.
#
# @param name - The identifier to which the extracted value will be bound.
# @param attribute - The response member from which the value will be extracted.
# @param plural - When the path is provided,
# @param path - The path within the member to extract.
# whether to extract a single match or a collection of all matching.
##
When(/^#{grave_param} is assigned the response #{response_attribute}#{traversal}$/) do
  |name, attribute, plural, path|
  perform { bind(name, dig_from_response(attribute, path, !plural.nil?)) }
end
