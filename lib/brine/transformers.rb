# Cucumber Step Argument Transformations
# Handle type conversions and template expansions

Transform /^.*{{.*}}.*$/ do |template|
  shave_value(template)
end

Transform /^\s*(-?\d+)\s*$/ do |number|
  number.to_i
end

Transform /^\s*\[.*\]\s*$/ do |array|
  array[1..-2].split(/\s*,\s*/).map{|it| Transform(it)}
end

Transform /^".*"$/ do |quoted|
  quoted[1..-2]
end

Transform /^\s*(?:true|false)\s*$/ do |boolean|
  boolean.to_s == "true"
end
