# brine.rb -- loader file for the rest of brine
#
# The primary goal of this file is to load all resources needed to use brine.
# A secondary goal which should inform how that is done is that loading this file by itself
# should provide new objects but not otherwise impact existing state such as by
# modifying the World or defining any Steps, Transforms, or similar.
# Those types of changes should be done by [#brine_mix].

require 'brine/cleaner_upper'
require 'brine/mustache_binder'
require 'brine/requester'
require 'brine/util'
require 'brine/selector'
require 'brine/type_checks'

# Modules to add to World
module Brine
  include CleanerUpper
  include MustacheBinder
  include Requesting
  include BrineUtil
  include Selection
  include TypeChecking
end

# Load the more side effecty files and return the Module,
# expected to be called as `World(brine_mix)`
def brine_mix
  require 'brine/step_definitions/assignment'
  require 'brine/step_definitions/request_construction'
  require 'brine/step_definitions/assertions'

  require 'brine/transforms'
  require 'brine/rest_steps'
  require 'brine/hooks'
  Brine
end
