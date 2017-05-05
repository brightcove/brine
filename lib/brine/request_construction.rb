#
# Request construction steps
#
When(/^the request body is:$/) do |input|
  set_request_body(input)
end

When(/^a (GET|POST|PATCH|PUT|DELETE) is sent to `([^`]*)`$/) do |method, url|
  send_request(parse_method(method), URI.escape(url))
  binding['response_parsed'] = response.body
  reset_request
end
