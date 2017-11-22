# assertions.rb - General assertions to be used with a Selector

Then(/^it is equal to `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| eq v}
end
Then(/^it is equal to:$/) do |value|
  selector.assert_that(value) {|v| eq v}
end
Then(/^it is matching `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| match v}
end
Then (/^it is matching:$/) do |value|
  selector.assert_that(value) {|v| match v}
end
Then(/^it is greater than `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| be > v}
end
Then(/^it is greater than or equal to `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| be >= v}
end
Then(/^it is less than `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| be < v}
end
Then(/^it is less than or equal to `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| be <= v}
end

Then(/^it is including `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| include v }
end
Then(/^it is including:$/) do |value|
  selector.assert_that(value) {|v| include v }
end

Then(/^it is a valid `([^`]*)`$/) do |type|
  selector.assert_that(type) {|t| type_check_for(t) }
end
