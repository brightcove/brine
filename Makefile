##
# Define information needed for this file itself.
##
BUILDSRC_DIR := buildsrc/

include ${BUILDSRC_DIR}gmsl
${BUILDSRC_DIR}bc/bml: ; git submodule init && git submodule update
include ${BUILDSRC_DIR}bc/bml

##
# Define local functions.
##

##
# Produce the directory for output generated for the specified runtime.
#
# This is extracted here to consolidate the convention.
#
# @param $1 Specify the runtime for which the output directory should be returned.
# @return Return the path to which output for specified runtime should be sent.
##
out-dir-for-runtime = $(abspath build/$1)/

##
# Validate called non-POSIX applications.
##

BUNDLE = $(call required-command,bundle)
GEM    = $(call required-command,gem)
PYTHON = $(call required-command,python)

##
# Define some global project structure and variables.
##

RUNTIMES         := ruby
BUILD_DIR        := build/
OUT_DIRS         += ${BUILD_DIR}
RUNTIME_OUT_DIRS := $(call map,out-dir-for-runtime,${RUNTIMES})
OUT_DIRS         += ${RUNTIME_OUT_DIRS}
PROJECT_REPO     := https://github.com/brightcove/brine
PROP_FILE        := build.properties

include ${PROP_FILE}
export VERSION

##
# Display general project information.
##

help: ; @cat ${BUILDSRC_DIR}/help
todo: ; @echo 'View issues at: ${PROJECT_REPO}/issues'

.PHONY: help todo

##
# Generate documentation.
##

SPHINX       = ${PYTHON} -msphinx
DOCS_SRCDIR := docs/
DOCS_OUTDIR := ${DOCS_SRCDIR}_build
OUT_DIRS    += ${DOCS_OUTDIR}

sphinx-help: ; @${SPHINX} -M help "${DOCS_SRCDIR}" "${DOCS_OUTDIR}"

.PHONY: sphinx-help docs

docs:
	@${SPHINX} -M html "${DOCS_SRCDIR}" "${DOCS_OUTDIR}"
	@echo "Docs created under file://$(realpath ${DOCS_OUTDIR})"

##
# Perform a code release.
##

release: ; ${BUILDSRC_DIR}/bc/release ${PROP_FILE}

.PHONY: release

##
# Configure ruby runtime specific tasks.
##

RUBY_OUT_DIR      := $(call out-dir-for-runtime,ruby)
BUNDLER_INSTALLED := ${RUBY_OUT_DIR}bundler_installed
GEMSPEC           := ${RUBY_OUT_DIR}brine-dsl.gem
ruby_SOURCES       = $(shell git ls-files ruby)

${BUNDLER_INSTALLED}: | ${RUBY_OUT_DIR}
	@echo "Running bundle install.."
	@cd ruby && ${BUNDLE} install
	@touch "$@"

ruby-check: export BRINE_ROOT_URL=http://www.example.com
ruby-check: ${BUNDLER_INSTALLED}
	cd ruby && ${BUNDLE} exec cucumber \
		--require $(abspath ruby/feature_setup.rb) \
		--require $(abspath ruby/lib/brine/test_steps.rb) \
		${CUCUMBER_OPTS} --tags 'not @pending' \
		$(abspath features)

${GEMSPEC}: ${BUNDLER_INSTALLED}
	cd ruby && ${GEM} build brine-dsl.gemspec -o $@

ruby-publish: ${GEMSPEC} ${BUNDLER_INSTALLED}
	${GEM} push $<

.PHONY: ruby-check ruby-publish

##
# Manage docker images.
##
# The docker targets should be able to be easily converted to pattern rules,
# but currently only ruby exists and some simplifications could precede other runtimes.
build/ruby.iid: ${ruby_SOURCES} ruby/Dockerfile | ${BUILD_DIR}
	@echo 'Building ruby image'
	@docker build ruby --iidfile $@ --build-arg brine_version=${VERSION} -t brine:${VERSION}-ruby

##
# Verify that the tutorial passes.
##

tutorial: export BRINE_ROOT_URL=https://api.myjson.com
tutorial: ${BUNDLER_INSTALLED}
	cd ruby && ${BUNDLE} exec cucumber --require $(abspath tutorial)/support/env.rb $(abspath tutorial)

.PHONY: tutorial

##
# Execute checks across all runtimes.
##

ALL_CHECKS := $(addsuffix -check, ${RUNTIMES})

check: ${ALL_CHECKS} tutorial
# Pass the feature directory to each check target.
%-check: export FEATURE=$(abspath features)

docker-ruby-check: build/ruby.iid
	@docker run --rm \
		--mount type=bind,src=$(abspath features),dst=/features \
		-e FEATURE=/features \
		-e CUCUMBER_OPTS="--require /app/brine/lib/brine/test_steps.rb --tags 'not @pending'" \
		brine:${VERSION}-ruby

.PHONY: check docker-ruby-check

##
# Define some utility tasks.
##

${OUT_DIRS}: ; mkdir -p $@

clean: ; rm -rf ${OUT_DIRS}

.PHONY: clean
