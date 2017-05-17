require 'brine/cleaner_upper'
require 'brine/mustache_binder'
require 'brine/requester'
require 'brine/util'
require 'brine/selector'

module Brine
  include CleanerUpper
  include MustacheBinder
  include Requester
  include BrineUtil
  include Selection
end

def brine_mix
  require 'brine/assignment'
  require 'brine/transforms'
  require 'brine/request_construction'
  require 'brine/rest_steps'
  require 'brine/hooks'
  Brine
end
