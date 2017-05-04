# Cucumber Step Argument Transformations
# Handle type conversions and template expansions

# Whitespace Removal
Transform /^\s+.*$/ do |input|
  Transform(input.strip)
end
Transform /^.*\s+$/ do |input|
  Transform(input.strip)
end

# Integers
Transform /^(-?\d+)$/ do |number|
  number.to_i
end

# Lists
Transform /^\[.*\]$/ do |input|
  JSON.parse(input)
end

# Objects
# Rely on templates being registered later and
# therefore given higher priority.
# Lookarounds could avoid the ambiguity but are
# a nastier pattern.
Transform /^{.*}$/ do |input|
  JSON.parse(input)
end

# Quotes
Transform /^".*"$/ do |quoted|
  quoted[1..-2]
end
Transform /^'.*'$/ do |quoted|
  quoted[1..-2]
end


# Boolean
Transform /^(?:true|false)$/ do |boolean|
  boolean.to_s == "true"
end

# DATE='\d{4}-\d{2}-\d{2}'
# TIME='\d{2}:\d{2}:\d{2}'
# MILLIS='(?:\.\d{3})?'
# TZ='(?:Z|(?:[+-]\d{2}:\d{2}))'
# Transform /^#{DATE}T#{TIME}#{MILLIS}#{TZ}$/ do |date|
#           DateTime.parse(date)
# end

# # Template Expansion
# Transform /^.*{{.*}}.*$/ do |template|
#   Transform(shave_value(template))
# end
