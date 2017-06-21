#
# Request construction steps
#
When(/^the request body is:$/) do |input|
  replaced_with('When', "the request body is assigned:", '0.4.0', input.to_json)
end
When(/^the request body is assigned:$/) do |input|
  set_request_body(input)
end

When(/^a (GET|POST|PATCH|PUT|DELETE) is sent to `([^`]*)`$/) do |method, url|
  send_request(parse_method(method), URI.escape(url))
  bind('response', response)
  reset_request
end
