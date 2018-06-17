# assignment.rb -- assignment related steps

# Assign `name' the value `value'.
When(/^`([^`]*)` is assigned `([^`]*)`$/) do |name, value|
  bind(name, value)
end

# Assign `name' a random string (UUID).
When(/^`([^`]*)` is assigned a random string$/) do |name|
  bind(name, SecureRandom.uuid)
end

# Assign `name' a temporal value corresponding to the current time.
When(/^`([^`]*)` is assigned a timestamp$/) do |name|
  bind(name, DateTime.now)
end
