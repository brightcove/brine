#
# Steps used to test this library
#

class StubResponse
  attr_reader :body

  def initialize(body)
    @body = body
  end
end

When(/^the response body is:$/) do |input|
  @response = StubResponse.new(input)
end

Then(/^the response body as JSON is:$/) do |text|
  expect(response.body.to_json).to eq text
end
