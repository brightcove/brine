require 'rspec'
#
# Steps used to test this library
# Not loaded by default (except in the tests)
#

require 'brine/selecting'

ENV['BRINE_DURATION_SECONDS_short'] = '3'
ENV['BRINE_DURATION_SECONDS_long'] = '6'

class StubResponse
  attr_accessor :body, :status, :headers

  def initialize
    @body = ''
    @status = 200
    @headers = {}
  end
end

class DelayedStubResponse < StubResponse

  def initialize(delay)
    super()
    @activation = Time.now + delay
  end

  def body
    Time.now < @activation ? nil : @body
  end

end

class StubRequest
  attr_accessor :method, :path, :headers, :body

  def initialize
    @headers = {}
  end

  def method=(value)
    @method=value.downcase.to_sym
  end
end

class StubBuilder
  attr_reader :request, :response

  def initialize
    @request = StubRequest.new
    @response = StubResponse.new
  end

  def make_response()
    [@response.status, {}, @response.body]
  end

  def build(stubs)
    # Currently the Faraday stub code provides one method per HTTP method (which then
    # calls a generalized protected method), so this block grabs the method to use
    # and passes the right args based on the signature. The last arg is normally a block
    # but we're using the make_response method to avoid duplication and allow overriding.
    m = stubs.method(@request.method)
    case m.parameters.length
      when 3
        m.call(@request.path, @request.headers, &method(:make_response))
      when 4
        m.call(@request.path, @request.body, @request.headers, &method(:make_response))
      else
        raise "I don't know how to call #{m}"
    end
  end
end

class ResponseStatusSequenceStubBuilder < StubBuilder
  def initialize(stub, seq)
    @request = stub.request
    @response = stub.response
    @enum = seq.to_enum
  end

  def make_response()
    begin
      @val = @enum.next
    end
    [@val, {}, @response.body]
  end
end
  
def stub
  @stub ||= StubBuilder.new
end

def build_stub
  stub.build($stubs)
  @stub = nil
end

Before do
  $stubs = Faraday::Adapter::Test::Stubs.new
  @client = Faraday.new(url: brine_root_url ||
                        'http://localhost:8080') do |conn|
    conn.response :logger, nil
    conn.adapter :test, $stubs
  end
end

Given('expected response status of {grave_param}') do |status|
  stub.response.status = status
end

Given('expected response status sequence of {grave_param}') do |seq|
  @stub = ResponseStatusSequenceStubBuilder.new(stub, seq)  
end

Given('expected request body:') do |body|
  stub.request.body = expand(transformed_parameter(body), binding)
end

Given('expected request headers:') do |headers|
  stub.request.headers = transformed_parameter(headers)
end

Given('expected {http_method} sent to {grave_param}') do |method, path|
  stub.request.method = method
  stub.request.path = path
  build_stub
end

When('the response body is assigned:') do |input|
    @response ||= StubResponse.new
    @response.body = transformed_parameter(input)
end

When('the response headers is assigned {grave_param}') do |input|
    @response ||= StubResponse.new
    @response.headers = input
end

When('the response body is assigned {grave_param}') do |input|
    @response ||= StubResponse.new
    @response.body = input
end

When('the response status is assigned {grave_param}') do |status|
  @response ||= StubResponse.new
  @response.status = status.to_i    # this coercion isn't needed but is a guarantee
end

When('the response is delayed {int} seconds') do |seconds|
   @response = DelayedStubResponse.new(seconds)
end

Then('the response body as JSON is:') do |text|
  expect(response.body.to_json).to eq text
end

Then('expected calls are verified') do
  $stubs.verify_stubbed_calls
end
