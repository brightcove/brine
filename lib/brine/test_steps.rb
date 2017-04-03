#
# Steps used to test this library
#

class StubResponse
  attr_reader :body

  def initialize(body)
    @body = body
  end
end

When(/^the response body contains the object:$/) do |table|
  @response = StubResponse.new(transform_table!(table).rows_hash.to_json)
end
