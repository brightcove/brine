require 'rspec'
require 'brine/util'
require 'brine/selector'
require 'jsonpath'

# Chopping Block
Then(/^the response #{RESPONSE_ATTRIBUTES} has `([^`]*)` with a value that is not empty$/) do
  |attribute, member|
  replaced_with('Then', "the value of the response #{attribute} child `#{member}` is not empty", '0.9')
end

Then(/^the response #{RESPONSE_ATTRIBUTES} includes? the entries:$/) do |attribute, table|
  replaced_with('Then', "the value of the response #{attribute} is including:", '0.9', kv_table(table).to_json)
end

Then(/^the response body is a list of length (\d+)$/) do |length|
  replaced_with('Then', "the value of the response body is of length `#{length}`", '0.9')
end

Then(/^the response body is a list (with|without) an entry containing:$/) do |with, data|
  neg = (with == 'without') ? 'not ' : ''
  replaced_with('Then', "the value of the response body does #{neg}have any element that is including:", '0.9', table.hashes.to_json)
end

Then(/^the response body has `([^`]*)` which (in|ex)cludes? the entries:$/) do
  |child, in_or_ex, table|
  neg = (in_or_ex=='ex') ? 'not ' : ''
  replaced_with('Then', "the value of the response body child `#{child}` is #{neg}including:", '0.9', kv_table(table).to_json)
end

# This file is legacy or unsorted steps which will be deprecated or moved into
# more appropriate homes

def not_if(val) val ? :not_to : :to end

# Return a table that that is a key value pair in a format ready for consumption
def kv_table(table)
  transform_table!(table).rows_hash
end

# TODO: Requires extensible is_a_valid for deprecation
Then(/^the response body is a list which all are (\w+)$/) do |matcher|
  pass_it = method(matcher.to_sym).call
  expect(response_body_child.first).to all(pass_it)
end

# FIXME: In the process of being deprecated
When(/^`([^`]*)` is bound to `([^`]*)` from the response body$/) do |name, path|
  binding[name] = response_body_child(path).first
end

#
# Response attribute (non-body) assertions
#
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
# TODO: Write specifications around this
Then(/^the response body does not contain fields:$/) do |table|
  expect(response_body_child.first.keys).to_not include(*table.raw.flatten)
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


Then(/^the response body is (\w+)$/) do |matcher|
  pass_it = method(matcher.to_sym).call
  expect(response_body_child.first).to pass_it
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

def response_body_child(path="")
  JsonPath.new("$.#{path}").on(response.body.to_json)
end
