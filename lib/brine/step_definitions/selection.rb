RESPONSE_ATTRIBUTES='(status|headers|body)'
Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? is( not)? (.*)(?<!:)$/) do
  |attribute, plural, path, negated, assertion|
  use_selector(Selector.new(dig_from_response(attribute, path, !plural.nil?), (!negated.nil?)))
  step "it is #{assertion}"
end

Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? is( not)? (.*)(?<=:)$/) do
  |attribute, plural, path, negated, assertion, multi|
  use_selector(Selector.new(dig_from_response(attribute, path, !plural.nil?), (!negated.nil?)))
  step "it is #{assertion}", multi.to_json
end