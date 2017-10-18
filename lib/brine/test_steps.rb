require 'rspec'
#
# Steps used to test this library
# Not loaded by default (except in the tests)
#
class StubResponse
  attr_accessor :body, :status
end

class Store < Faraday::Adapter
  attr_reader :calls

  def initialize(app, calls)
    super(app)
    @calls = calls
  end

  def call(env)
    @calls << env
    save_response(env, '200', env.body, {})
    @app.call(env)
  end
end

Faraday::Adapter.register_middleware \
  :store => lambda { Store }

Before do
  @calls = []
  @client = Faraday.new(url: ENV['ROOT_URL'] ||
                        'http://localhost:8080') do |conn|
    conn.adapter :store, @calls
  end
end

class RequestMatcher
  attr_accessor :method, :url, :body, :headers
end

RSpec::Matchers.define :include_a_request_like do |req|
  match(:notify_expectation_failures => true) do |calls|
    atts = {:url    => have_attributes(:request_uri => match(req.url)),
            :method => req.method,
            :body   => req.body}
    atts[:request_headers] = req.headers if req.headers
    expect(calls).to include(have_attributes(atts))
  end
end

RSpec::Matchers.define_negated_matcher :not_match, :match

When(/^the response body is assigned:$/) do |input|
    @response ||= StubResponse.new
    @response.body = input
end

When(/^the response body is assigned `([^`]*)`/) do |input|
    @response ||= StubResponse.new
    @response.body = input
end

When(/^the response body is:$/) do |input|
  replaced_with('When', 'the response body is assigned:', '1.0.0', input.to_json)
end

When /^the response status is assigned `([^`]*)`$/ do |status|
  @response ||= StubResponse.new
  @response.status = status.to_i    # this coercion isn't needed but is a guarantee
end

Then(/^the response body as JSON is:$/) do |text|
  expect(response.body.to_json).to eq text
end

Then (/^there was a (GET|POST|PATCH|PUT|DELETE|HEAD|OPTIONS) request with a url matching `([^`]*)`$/) do
  |method, url|
  @req_check = RequestMatcher.new
  @req_check.method = parse_method(method)
  @req_check.url = url
end
Then (/^there was a (GET|POST|PATCH|PUT|DELETE|HEAD|OPTIONS) request sent with a url matching `([^`]*)`$/) do
  |method, url|
  req_check = RequestMatcher.new
  req_check.method = parse_method(method)
  req_check.url = url
  expect(@calls).to include_a_request_like(req_check)
end

Then (/^it had a body matching:$/) do |body|
  @req_check.body = match(body)
end
Then (/^it had a body not matching:$/) do |body|
  @req_check.body = not_match(body)
end

Then (/^it had headers including `([^`]*)`$/) do |header|
  @req_check.headers = include(header)
end

Then (/^it was sent$/) do
  expect(@calls).to include_a_request_like(@req_check)
end
