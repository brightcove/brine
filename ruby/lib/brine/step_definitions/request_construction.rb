# request_construction.rb - Build and send requests

When(/^the request body is assigned:$/) do |input|
  perform { set_request_body(input) }
end

When(/^the request query parameter `([^`]*)` is assigned `([^`]*)`$/) do |param, value|
  perform { set_request_param(param, value) }
end

When(/^the request header `([^`]*)` is assigned `([^`]*)`$/) do |header, value|
  perform { set_header(header, value) }
end

When(/^the request credentials are set for basic auth user `([^`]*)` and password `([^`]*)`$/) do |user, password|
  perform do
    base64_combined = Base64.strict_encode64("#{user}:#{password}")
    set_header('Authorization', "Basic #{base64_combined}")
  end
end

When(/^an? (GET|POST|PATCH|PUT|DELETE|HEAD|OPTIONS) is sent to `([^`]*)`$/) do |method, url|
  perform do
    send_request(parse_method(method), URI.escape(url))
    bind('response', response)
    reset_request
  end
end
