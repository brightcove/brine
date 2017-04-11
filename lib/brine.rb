require 'brine/cleaner_upper'
require 'brine/mustache_binder'
require 'brine/requester'
require 'brine/util'

module Brine
  include CleanerUpper
  include MustacheBinder
  include Requester
  include BrineUtil
end

def brine_mix
  require 'brine/transformers'
  require 'brine/rest_steps'
  require 'brine/hooks'
  Brine
end
