# cleanup.rb - Track information needed for Resource Cleanup

grave_param='`([^`]*)`'

When(/^a resource is created at #{grave_param}$/) do |path|
  perform { track_created_resource path }
end
