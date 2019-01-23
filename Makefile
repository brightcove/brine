include buildsrc/gmsl

######################
# Make Library Stuff #
######################
# Likely to be reused and should be extracted accordingly.

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

###################
# Local Functions #
###################

##
# The directory for output generated for the specified runtime.
#
# This is extracted here to consolidate the convention.
#
# @param $1[in] The runtime for which the output directory should be returned.
# @return The path to which output for runtime @p $1 should be sent.
##
out-dir-for-runtime = $(abspath build/$1)/

################
# Dependencies #
################

BUNDLE := $(call required-command,bundle)
PYTHON := $(call required-command,python)

########
# Help #
########

.PHONY: help
help: ; @cat .make/help

#####################
# Project Structure #
#####################

RUNTIMES         := ruby

RUNTIME_OUT_DIRS := $(call map,out-dir-for-runtime,${RUNTIMES})
OUT_DIRS         += ${RUNTIME_OUT_DIRS}

${OUT_DIRS}: ; mkdir -p $@

#########################
# Inter-Runtime Targets #
#########################

ALL_CHECKS = $(addsuffix -check, ${RUNTIMES})

.PHONY: check clean
check: ${ALL_CHECKS} tutorial
# Pass the feature directory to each check target.
%-check: export FEATURE=$(abspath features)

clean: ; rm -rf ${OUT_DIRS}

########
# Docs #
########

SPHINX       = ${PYTHON} -msphinx
DOCS_SRCDIR := docs/
DOCS_OUTDIR := ${DOCS_SRCDIR}_build
OUT_DIRS    += ${DOCS_OUTDIR}

.PHONY: sphinx-help docs

sphinx-help: ; @${SPHINX} -M help "${DOCS_SRCDIR}" "${DOCS_OUTDIR}"

docs: ; @${SPHINX} -M html "${DOCS_SRCDIR}" "${DOCS_OUTDIR}"

########
# Ruby #
########

RUBY_OUT_DIR := $(call out-dir-for-runtime,ruby)

## Bundler Dance ##
${RUBY_OUT_DIR}bundler_installed: | ${RUBY_OUT_DIR}
	cd ruby && ${BUNDLE} install > $@
${RUBY_OUT_DIR}bundler_updated: ${RUBY_OUT_DIR}bundler_installed
	cd ruby && ${BUNDLE} update > $@

.PHONY: ruby-check
ruby-check: ${RUBY_OUT_DIR}bundler_updated
	export ROOT_URL=http://www.example.com; \
	export CUCUMBER_OPTS="--require $(abspath ruby/feature_setup.rb)"; \
	cd ruby && ${BUNDLE} exec rake check

############
# Tutorial #
############

.PHONY: tutorial
tutorial: export FEATURE=$(abspath tutorial)
tutorial: ${RUBY_OUT_DIR}bundler_updated
	export ROOT_URL=https://api.myjson.com; \
	export CUCUMBER_OPTS="--require ${FEATURE}/support/env.rb"; \
	cd ruby && ${BUNDLE} exec rake check
