##
# @file brine.rb
# Loader file for the rest of brine.
#
# The primary goal of this file is to load all resources needed to use brine.
# A secondary goal which should inform how that is done is that loading this
# file by itself should provide new objects but not otherwise impact existing
# state such as by  modifying the World or defining any Steps, Transforms, etc.
# Those types of changes should be done by @ref #brine_mix.

require 'brine/cleaner_upper'
require 'brine/mustache_binder'
require 'brine/requester'
require 'brine/util'
require 'brine/selector'
require 'brine/type_checks'

##
# Meta-module for modules to mix into World.
module Brine
  include CleanerUpper
  include MustacheBinder
  include Requesting
  include BrineUtil
  include Selection
  include TypeChecking
end

##
# Load the files with side effects and return @ref Brine.
#
# Expected to be called as `World(brine_mix)`
def brine_mix
  require 'brine/step_definitions/assignment'
  require 'brine/step_definitions/request_construction'
  require 'brine/step_definitions/assertions'
  require 'brine/step_definitions/cleanup'
  require 'brine/step_definitions/selection'

  require 'brine/transforms'
  require 'brine/rest_steps'
  require 'brine/hooks'
  Brine
end
