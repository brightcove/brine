require 'rspec'
require 'brine/util'
require 'brine/selector'

# This file is legacy or unsorted steps which will be deprecated or moved into
# more appropriate homes

def not_if(val) val ? :not_to : :to end

# Return a table that that is a key value pair in a format ready for consumption
def kv_table(table)
  transform_table!(table).rows_hash
end

When(/^`([^`]*)` is bound to a random string$/) do |name|
  replaced_with('When', "#{name} is assigned a random string", '0.4')
end
When(/^`([^`]*)` is bound to `([^`]*)`$/) do |name, value|
  replaced_with('When', "#{name} is assigned #{value}", '0.4')
end
When(/^`([^`]*)` is bound to a timestamp$/) do |name|
  replaced_with('When', "#{name} is assigned #{value}", '0.4')
end

#TODO: The binding environment should be able to be accessed directly
# without requiring a custom step
When(/^`([^`]*)` is bound to `([^`]*)` from the response body$/) do |name, path|
  binding[name] = response_body_child(path).first
end

When(/^the request parameter `([^`]*)` is set to `([^`]*)`$/) do |param, value|
  add_request_param(param, value)
end

#
# Cleanup
#
When(/^a resource is created at `([^`]*)`$/) do |path|
  track_created_resource path
end

#
# Assertions
#
Then(/^it is equal to `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| eq v}
end
Then(/^it is greater than `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| be > v}
end
Then(/^it is greater than or equal to `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| be >= v}
end
Then(/^it is less than `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| be < v}
end
Then(/^it is less than or equal to `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| be <= v}
end


#
# Response attribute (non-body) assertions
#

Then(/^the response #{RESPONSE_ATTRIBUTES} has `([^`]*)` with a value that is not empty$/) do
  |attribute, member|
  expect(response).to have_attributes(attribute.to_sym => include(member.to_sym => be_not_empty))
end

Then(/^the response #{RESPONSE_ATTRIBUTES} has `([^`]*)` with a value including `([^`]*)`$/) do
  |attribute, member, value|
  expect(response).to have_attributes(attribute.to_sym => include(member => include(value)))
end

Then(/^the response #{RESPONSE_ATTRIBUTES} equals `([^`]*)`$/) do |attribute, value|
  replaced_with('Then', "the response #{attribute} is equal to `#{value}`", "0.4")
end

Then(/^the response #{RESPONSE_ATTRIBUTES} includes? the entries:$/) do |attribute, table|
  expect(response).to have_attributes(attribute.to_sym => include(kv_table(table)))
end

Then(/^the response #{RESPONSE_ATTRIBUTES} contains? null fields:$/) do |attribute, table|
  expect(response)
    .to have_attributes(attribute.to_sym =>
                        include(table.raw.flatten.collect{|v| [v, be_nil]}.to_h))
end

Then(/^the response #{RESPONSE_ATTRIBUTES} contains? non null fields:$/) do |attribute, table|
  expect(response)
    .to have_attributes(attribute.to_sym =>
                        include(table.raw.flatten.collect{|v| [v, be_not_nil]}.to_h))
end

#
# Response body assertions
#
Then(/^the response body is the list:$/) do |table|
  expect(response_body_child.first).to eq table.hashes
end

Then(/^the response body does not contain fields:$/) do |table|
  expect(response_body_child.first.keys).to_not include(*table.raw.flatten)
end

Then(/^the response body contains? non null fields:$/) do |table|
  expect(response_body_child.first)
    .to include(table.raw.flatten
                  .collect{|v| [v, be_not_nil]}.to_h)
end

Then(/^the response body contains? null fields:$/) do |table|
  expect(response_body_child.first)
    .to include(table.raw.flatten
                  .collect{|v| [v, be_nil]}.to_h)
end

Then(/^the response body has `([^`]*)` which (in|ex)cludes? the entries:$/) do
  |child, in_or_ex, table|
  expect(response_body_child(child).first)
    .send(not_if(in_or_ex=='ex'),
          include(kv_table(table)))
end

Then(/^the response body has `([^`]*)` with a value including `([^`]*)`$/) do |child, value|
  expect(response_body_child(child).first).to include(value)
end

Then(/^the response body has `([^`]*)` with a value equal to `([^`]*)`$/) do |child, value|
  expect(response_body_child(child).first).to eq(value)
end

Then(/^the response body has `([^`]*)` with a value that is not empty$/) do |child|
  expect(response_body_child(child).first).to be_not_empty
end

Then(/^the response body is a list which all are (\w+)$/) do |matcher|
  pass_it = method(matcher.to_sym).call
  expect(response_body_child.first).to all(pass_it)
end

Then(/^the response body is a list of length (\d+)$/) do |length|
  expect(response_body_child.first).to have_attributes(length: length)
end

#TODO: Maybe worth optimizing these 2 to O(n) after tests are in place
Then(/^the response body is a list sorted by `([^`]*)` ascending$/) do |path|
  values = response_body_child(path)
  expect(values).to eq values.sort{|a,b| a.to_s.downcase <=> b.to_s.downcase}
end

Then(/^the response body is a list sorted by `([^`]*)` descending$/) do |path|
  values = response_body_child(path)
  expect(values).to eq values.sort{|a,b| b.to_s.downcase <=> a.to_s.downcase}
end

Then(/^the response body is a list (with|without) an entry containing:$/) do |with, data|
  expect(response_body_child.first)
    .send(not_if(with == 'without'),
          include(include(kv_table(data))))
end

Then(/^the response body is (\w+)$/) do |matcher|
  pass_it = method(matcher.to_sym).call
  expect(response_body_child.first).to pass_it
end

Then(/^the raw response body is:$/) do |text|
  expect(response.body).to eq text
end

#
# Polling assertions
#
Then(/^a non\-empty list is eventually returned at `([^`]*)`$/) do |path|
  retry_for(120, 3) do
    send_request(parse_method('GET'), path)
    expect(response_body_child.first).to_not be_empty
  end
end

Then(/^the resource is eventually available at `([^`]*)`$/) do |path|
  retry_for(120, 3) do
    send_request(parse_method('GET'), path)
    expect(response).to have_attributes(:status => 200)
  end
end

# TODO: Parameterize polling length
Then(/^the property `([^`]*)` is eventually `([^`]*)` at `([^`]*)`$/) do |field, value, path|
  retry_for(180) do
    send_request(parse_method('GET'), path)
    expect(response_body_child.first).to include(field => value)
  end
end

When(/^`([^`]*)` is assigned a random string$/) do |name|
  bind(name, SecureRandom.uuid)
end

When(/^`([^`]*)` is assigned `([^`]*)`$/) do |name, value|
  bind(name, value)
end

When(/^`([^`]*)` is assigned a timestamp$/) do |name|
  bind(name, DateTime.now)
end
