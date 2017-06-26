# assertions.rb

Then(/^it is equal to `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| eq v}
end
Then(/^it is equal to:$/) do |value|
  selector.assert_that(value) {|v| eq v}
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

Then(/^is is including `([^`]*)`$/) do |value|
  selector.assert_that(value) {|v| include v }
end
Then(/^it is including:$/) do |value|
  selector.assert_that(value) {|v| include v }
end
