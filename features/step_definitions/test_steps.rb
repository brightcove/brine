# the output should contain: is useful for seeing failures
# TODO: Sway this out with standard aruba step
Then(/^it should pass$/) do
  expect(last_command_started).to be_successfully_executed
end
