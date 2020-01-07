##
# @file feature_setup.rb
# Support needed to run Brine features.
#
# The Brine `features` directory is runtime-agnostic, so any
# provided runtime needs to configure itself to be able to
# execute the provided specs (docs to come).
# This file does that work for the ruby runtime.
#
# This file is also used in the Docker image to enable Brine
# for mounted features.
#
# It is left at the top level to keep it slightly more isolated
# from the rest of the code and as a minor convenience for
# referencing the file from the top-level build.
##

require 'brine'
World(brine_mix)
