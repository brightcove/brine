# request_construction.rb - Build and send requests

grave_param='`([^`]*)`'

When(/^the request body is assigned:$/) do |input|
  perform { set_request_body(input) }
end

When(/^the request query parameter #{grave_param} is assigned #{grave_param}$/) do |param, value|
  perform { set_request_param(param, value) }
end

When(/^the request header #{grave_param} is assigned #{grave_param}$/) do |header, value|
  perform { set_header(header, value) }
end

When(/^the request credentials are set for basic auth user #{grave_param} and password #{grave_param}$/) do |user, password|
  perform do
    base64_combined = Base64.strict_encode64("#{user}:#{password}")
    set_header('Authorization', "Basic #{base64_combined}")
  end
end

http_method='(GET|POST|PATCH|PUT|DELETE|HEAD|OPTIONS)'
When(/^an? #{http_method} is sent to #{grave_param}$/) do |method, url|
  perform do
    send_request(parse_method(method), URI.escape(url))
    bind('response', response)
    reset_request
  end
end
