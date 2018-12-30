######################
# Make Library Stuff #
######################
# These are likely to be reused and should be extracted accordingly.

##
# The path to a required command; abort with an error if not found.
#
# The requested command must be on the PATH/located by `which`.
#
# @param $1[in] The basename of the command to seek.
# @return The path to the command, make will abort if not found.
##
required-command = $(or ${_$1_which},					\
                        $(eval _$1_which=$(shell which $1)),		\
                        ${_$1_which},					\
			$(error '$1' is missing, please install $1))

################
# Dependencies #
################

BUNDLE := $(call required-command,bundle)

########
# Help #
########

.PHONY: help
help: ; @cat .make/help

#####################
# Project Structure #
#####################

BUILD_DIR := build/
OUT_DIRS  += ${BUILD_DIR}

${OUT_DIRS}: ; mkdir -p $@

###################
# Realish Targets #
###################

## Bundler Dance ##
${BUILD_DIR}bundler_installed: | ${BUILD_DIR}
	${BUNDLE} install > $@
${BUILD_DIR}bundler_updated: ${BUILD_DIR}bundler_installed
	${BUNDLE} update > $@

.PHONY: check clean
check: ${BUILD_DIR}bundler_updated
	${BUNDLE} exec rake check

clean: ; rm -rf ${OUT_DIRS}
