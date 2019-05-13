##
# @file hooks.rb
# Cucumber hook callbacks used by Brine.
##

##
# Call CleanerUpper after the test run.
##
After do
  cleanup_created_resources
end
