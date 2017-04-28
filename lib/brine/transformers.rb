# Cucumber Step Argument Transformations
# Handle type conversions and template expansions

# Match template braces optionally surrounded by whitespace
Transform /^.*{{.*}}.*$/ do |template|
  shave_value(template)
end

# Match numbers with possible - optionally surrounded by whitespace
Transform /^\s*(-?\d+)\s*$/ do |number|
  number.to_i
end

# Match array braces optionally surrounded by braces
Transform /^\s*\[.*\]\s*$/ do |array|
  # Also ignore any spaces around the ,s
  array[1..-2].strip.split(/\s*,\s*/).map{|it| Transform(it)}
end

# Preserve value/stringiness within quotes optionally surrounded by whitespace
Transform /^\s*".*"\s*$/ do |quoted|
  quoted[1..-2]
end

# Match true or false optionally surrounded by whitespace
Transform /^\s*(?:true|false)\s*$/ do |boolean|
  boolean.to_s == "true"
end
