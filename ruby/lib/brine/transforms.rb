# = transformers.rb:: Argument Transforms for Brine
#
# The Transforms that convert provided inputs to support richer
# functionaliy than the simple strings which Cucumber provides.

# == Scalar transforms
# Convert inputs into basic Ruby data types which represent a single value

# Integers
Transform /\A(-?\d+)\z/ do |number|
  number.to_i
end

# Booleans
Transform /\A(?:true|false)\z/ do |boolean|
  boolean.to_s == "true"
end

# Regexp
# This presently does not support flags after the closing slash, support for these should be added as needed
Transform /\A\/(.*)\/\z/ do |pattern|
  Regexp.new(pattern)
end

# Temporal
DATE='\d{4}-\d{2}-\d{2}'
TIME='\d{2}:\d{2}:\d{2}'
MILLIS='(?:\.\d{3})?'
TZ='(?:Z|(?:[+-]\d{2}:\d{2}))'
Transform /^#{DATE}T#{TIME}#{MILLIS}#{TZ}$/ do |date|
          Time.parse(date)
end

# == Structure transforms
# Converts inputs to general data structures

# Lists
Transform /\A\[.*\]\z/m do |input|
  JSON.parse(input)
end

# Objects
# Rely on templates being registered later and therefore given higher priority.
# Lookarounds could avoid the ambiguity but are a nastier pattern.
Transform /\A{.*}\z$/m do |input|
    JSON.parse(input)
end

# == Atypical transforms
# Transforms for which data type is not the primary focus

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
Transform /\A\s+(.*)\z/m do |input|
  Transform(input.strip)
end
Transform /\A(.*)\s+\z/m do |input|
  Transform(input.strip)
end

# Quotes
Transform /\A".*"\z/ do |quoted|
  quoted[1..-2]
end
Transform /\A'.*'\z/ do |quoted|
  quoted[1..-2]
end

# Template Expansion
Transform /.*{{.*}}.*/ do |template|
  Transform(shave_value(template))
end
