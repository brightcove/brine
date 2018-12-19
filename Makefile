################
# Dependencies #
################

BUNDLER_BIN ?= $(shell which bundler)
BUNDLER      = $(if ${BUNDLER_BIN},${BUNDLER_BIN},$(error "bundler is required, please install Bundler."))

########
# Help #
########

.PHONY: help
help:
	@cat .make/help

#####################
# Project Structure #
#####################

BUILD_DIR=build/
${BUILD_DIR}:
	mkdir -p $@

###################
# Realish Targets #
###################

## Bundler Dance ##
${BUILD_DIR}bundler_installed: | ${BUILD_DIR}
	bundler install > $@
${BUILD_DIR}bundler_updated: ${BUILD_DIR}bundler_installed
	bundler update > $@

.PHONY: check clean

check: ${BUILD_DIR}bundler_updated
	bundler exec rake check

clean:
	rm -rf ${BUILD_DIR}
