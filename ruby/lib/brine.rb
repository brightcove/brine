##
# @file brine.rb
# Support loading Brine into the World.
##

##
# Load all Brine files into the World.
#
# Expected to be called as `World(brine_mix)`
#
# @return [module] Return the `Brine` module.
##
def brine_mix
  require 'brine/assertions'
  require 'brine/assigning'
  require 'brine/cleaning_up'
  require 'brine/hooks'
  require 'brine/mustache_expanding'
  require 'brine/performing'
  require 'brine/requesting'
  require 'brine/selecting'
  require 'brine/transforming'
  require 'brine/type_checking'
  Brine
end
