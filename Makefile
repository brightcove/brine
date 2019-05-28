include buildsrc/gmsl
buildsrc/bc/bml: ; git submodule init && git submodule update
include buildsrc/bc/bml

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

BUNDLE = $(call required-command,bundle)
PYTHON = $(call required-command,python)

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

docs:
	@${SPHINX} -M html "${DOCS_SRCDIR}" "${DOCS_OUTDIR}"
	@echo "Docs created under file://$(realpath ${DOCS_OUTDIR})"

###########
# Release #
###########

.PHONY: release
release: ; buildsrc/bc/release build.properties

include build.properties
export VERSION

########
# Ruby #
########

RUBY_OUT_DIR := $(call out-dir-for-runtime,ruby)

## Bundler Dance ##
${RUBY_OUT_DIR}bundler_installed: | ${RUBY_OUT_DIR}
	@echo "Running bundle install.."
	@cd ruby && ${BUNDLE} install --path "${RUBY_OUT_DIR}"
	@touch "$@"

${RUBY_OUT_DIR}bundler_updated: ${RUBY_OUT_DIR}bundler_installed
	@echo "Running bundle update.."
	@cd ruby && ${BUNDLE} update
	@touch "$@"

.PHONY: ruby-check ruby-publish
ruby-check: ${RUBY_OUT_DIR}bundler_updated
	export BRINE_ROOT_URL=http://www.example.com; \
	export CUCUMBER_OPTS="$$CUCUMBER_OPTS --require $(abspath ruby/feature_setup.rb)"; \
	cd ruby && ${BUNDLE} exec rake check

ruby-publish: ${RUBY_OUT_DIR}bundler_updated
	cd ruby && ${BUNDLE} exec rake release

############
# Tutorial #
############

.PHONY: tutorial
tutorial: export FEATURE=$(abspath tutorial)
tutorial: ${RUBY_OUT_DIR}bundler_updated
	export BRINE_ROOT_URL=https://api.myjson.com; \
	export CUCUMBER_OPTS="--require ${FEATURE}/support/env.rb"; \
	cd ruby && ${BUNDLE} exec rake check
