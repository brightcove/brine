# assignment.rb

When(/^`([^`]*)` is assigned a random string$/) do |name|
  bind(name, SecureRandom.uuid)
end

When(/^`([^`]*)` is assigned `([^`]*)`$/) do |name, value|
  bind(name, value)
end

When(/^`([^`]*)` is assigned a timestamp$/) do |name|
  bind(name, DateTime.now)
end
