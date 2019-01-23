# cleanup.rb - Track information needed for Resource Cleanup
When(/^a resource is created at `([^`]*)`$/) do |path|
  track_created_resource path
end