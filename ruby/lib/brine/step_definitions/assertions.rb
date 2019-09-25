# assertions.rb - General assertions to be used with a Selector

grave_param='`([^`]*)`'

Then(/^it is equal to #{grave_param}$/) do |value|
  perform { selector.assert_that(value) {|v| eq v} }
end
Then(/^it is equal to:$/) do |value|
  perform { selector.assert_that(value) {|v| eq v} }
end
Then(/^it is matching #{grave_param}$/) do |value|
  perform { selector.assert_that(value) {|v| match v} }
end
Then (/^it is matching:$/) do |value|
  perform { selector.assert_that(value) {|v| match v} }
end
Then(/^it is greater than #{grave_param}$/) do |value|
  perform { selector.assert_that(value) {|v| be > v} }
end
Then(/^it is greater than or equal to #{grave_param}$/) do |value|
  perform { selector.assert_that(value) {|v| be >= v} }
end
Then(/^it is less than #{grave_param}$/) do |value|
  perform { selector.assert_that(value) {|v| be < v} }
end
Then(/^it is less than or equal to #{grave_param}$/) do |value|
  perform { selector.assert_that(value) {|v| be <= v} }
end

# Be a little smarter than default.
Then(/^it is empty$/) do
  perform { selector.assert_that(nil) do
    satisfy{|i| i.nil? || (i.respond_to?(:empty?) && i.empty?) }
  end }
end

Then(/^it is including #{grave_param}$/) do |value|
  perform { selector.assert_that(value) {|v| include v } }
end
Then(/^it is including:$/) do |value|
  perform { selector.assert_that(value) {|v| include v } }
end

Then(/^it is a valid #{grave_param}$/) do |type|
  perform { selector.assert_that(type) {|t| type_check_for(t) } }
end

Then(/^it is of length #{grave_param}$/) do |length|
  perform { selector.assert_that(length) do |l|
    satisfy{|i| i.respond_to?(:length) && i.length == l}
  end }
end
