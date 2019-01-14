# request_construction.rb - Build and send requests
require 'base64'

When(/^the request body is assigned:$/) do |input|
  set_request_body(input)
end

When(/^the request query parameter `([^`]*)` is assigned `([^`]*)`$/) do |param, value|
  add_request_param(param, value)
end

When(/^the request header `([^`]*)` is assigned `([^`]*)`$/) do |header, value|
  add_header(header, value)
end

When (/^the request credentials are set for basic auth user `([^`]*)` and password `([^`]*)`$/) do |user, password|
  add_header('Authorization', 'Basic ' + Base64.strict_encode64(user + ':' + password))
end

When(/^an? (GET|POST|PATCH|PUT|DELETE|HEAD|OPTIONS) is sent to `([^`]*)`$/) do |method, url|
  send_request(parse_method(method), URI.escape(url))
  bind('response', response)
  reset_request
end
