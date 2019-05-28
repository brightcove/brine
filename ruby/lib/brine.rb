##
# @file brine.rb
# Loader file for the rest of brine.
#
# The primary goal of this file is to load all resources needed to use brine.
# A secondary goal which should inform how that is done is that loading this
# file by itself should provide new objects but not otherwise impact existing
# state such as by modifying the World or defining any Steps, Transforms, etc.
# Those types of changes should be done by @ref #brine_mix.
##

require 'brine/cleaning_up'
require 'brine/mustache_expanding'
require 'brine/performing'
require 'brine/requesting'
require 'brine/selecting'
require 'brine/type_checking'

##
# Load the files with side effects.
#
# Expected to be called as `World(brine_mix)`
# @return [module] The `Brine` module.
##
def brine_mix
  require 'brine/step_definitions/assignment'
  require 'brine/step_definitions/request_construction'
  require 'brine/step_definitions/assertions'
  require 'brine/step_definitions/cleanup'
  require 'brine/step_definitions/perform'
  require 'brine/step_definitions/selection'

  require 'brine/transforms'
  require 'brine/hooks'

  Brine
end
