##
# @file hooks.rb
# Register Brine callbacks for Cucumber hooks.
##

##
# Call CleanerUpper after the test run.
##
After do
  cleanup_created_resources
end
