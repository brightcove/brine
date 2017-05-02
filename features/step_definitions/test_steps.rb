# the output should contain: is useful for seeing failures
Then(/^it should pass$/) do
  expect(last_command_started).to be_successfully_executed
end
