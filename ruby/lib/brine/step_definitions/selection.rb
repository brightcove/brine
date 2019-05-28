#RESPONSE_ATTRIBUTES='(status|headers|body)'
Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? is( not)? (.*)(?<!:)$/) do
  |attribute, plural, path, negated, assertion|
  perform do
    select(dig_from_response(attribute, path, !plural.nil?), (!negated.nil?))
    step "it is #{assertion}"
  end
end

Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? is( not)? (.*)(?<=:)$/) do
  |attribute, plural, path, negated, assertion, multi|
  perform do
    select(dig_from_response(attribute, path, !plural.nil?), (!negated.nil?))
    step "it is #{assertion}", multi.to_json
  end
end

Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? does( not)? have any element that is (.*)(?<!:)$/) do
  |attribute, plural, path, negated, assertion|
  perform do
    select_any(dig_from_response(attribute, path, !plural.nil?), (!negated.nil?))
    step "it is #{assertion}"
  end
end

Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? does( not)? have any element that is (.*)(?<=:)$/) do
  |attribute, plural, path, negated, assertion, multi|
  perform do
    select_any(dig_from_response(attribute, path, !plural.nil?), (!negated.nil?))
    step "it is #{assertion}", multi.to_json
  end
end

#Would be negated with `not all' which would be equivalent to any(not ) but that's not readily supported
Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? has elements which are all (.*)(?<!:)$/) do
  |attribute, plural, path, assertion|
  perform do
    select_all(dig_from_response(attribute, path, !plural.nil?), false)
    step "it is #{assertion}"
  end
end

Then(/^the value of the response #{RESPONSE_ATTRIBUTES}(?: child(ren)? `([^`]*)`)? has elements which are all (.*)(?<=:)$/) do
  |attribute, plural, path, assertion, multi|
  perform do
    select_all(dig_from_response(attribute, path, !plural.nil?), false)
    step "it is #{assertion}", multi.to_json
  end
end
