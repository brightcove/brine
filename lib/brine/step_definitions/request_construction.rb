#
# Request construction steps
#
When(/^the request body is assigned:$/) do |input|
  set_request_body(input)
end

When(/^an? (GET|POST|PATCH|PUT|DELETE|HEAD|OPTIONS) is sent to `([^`]*)`$/) do |method, url|
  send_request(parse_method(method), URI.escape(url))
  bind('response', response)
  reset_request
end
