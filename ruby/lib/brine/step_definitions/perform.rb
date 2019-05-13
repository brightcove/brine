##
# @file perform.rb
# Steps related to performing actions
##

When /^actions are defined such that$/ do
  collect_actions
end

Then /^the actions are( not)? successful within a `([^`]*)` period$/ do |negated, period|
  method = negated ? :to : :to_not
  expect { poll_for(retrieve_duration(period)) {
    performer.evaluate
  } }.send(method, raise_error)
  reset_performer
end
