require 'rspec'
#
# Steps used to test this library
# Not loaded by default (except in the tests)
#
class StubResponse
  attr_accessor :body, :code
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
  attr_accessor :method, :url, :body
end

RSpec::Matchers.define :include_a_request_like do |req|
  match(:notify_expectation_failures => true) do |calls|
    expect(calls)
      .to include(
            have_attributes(:url => have_attributes(:request_uri => match(req.url)),
                            :method => req.method,
                            :body => req.body))
  end
end

RSpec::Matchers.define_negated_matcher :not_match, :match

When(/^the response body is assigned:$/) do |input|
  @response ||= StubResponse.new
  @response.body = input
end

When /^the response code is assigned `([^`]*)`$/ do |code|
  @response ||= StubResponse.new
  @response.code = code.to_i    # this coercion isn't needed but is a guarantee
end

Then(/^the response body as JSON is:$/) do |text|
  expect(response.body.to_json).to eq text
end

Then (/^there was a (GET|POST|PATCH|PUT|DELETE) request with a url matching `([^`]*)`$/) do
  |method, url|
  @req_check = RequestMatcher.new
  @req_check.method = parse_method(method)
  @req_check.url = url
end
Then (/^it had a body matching:$/) do |body|
  @req_check.body = match(body)
end
Then (/^it had a body not matching:$/) do |body|
  @req_check.body = not_match(body)
end


Then (/^it was sent$/) do
  expect(@calls).to include_a_request_like(@req_check)
end
