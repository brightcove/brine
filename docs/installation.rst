############
Installation
############

******************
Using the Ruby Gem
******************

Brine is published as `brine-dsl <https://rubygems.org/gems/brine-dsl>`_ on rubygems.
The latest version and other gem metadata can be viewed there. Brine can be used by
declaring that gem in your project ``Gemfile`` such as:

.. code-block:: ruby

   gem 'brine-dsl', "~> #{brine_version}"

where ``brine_version`` is set to the desired version, currently '|version|'.

Brine can then be "mixed in" to your project (which adds assorted modules to
the :keyword:`World` and loads all the step definitions and other Cucumber
magic) by adding the following to your :file:`support/env.rb` or other ruby file:

.. code-block:: ruby

   require 'brine'
   World(brine_mix)

Select pieces can also be loaded (to be documented). With the above, feature files
should be able to be written and executed without requiring any additional ruby code.

************
Using Docker
************

A `Docker image <https://hub.docker.com/repository/docker/mwhipple/brine>`_
is provided which can be used to execute any test suite that doesn't
require additional dependencies (it could also assist with projects that do have
additional dependencies, but that is undocumented and may be better addressed by a
custom image).

This can be done most simply by bind mounting the directory of feature files to the
``/features`` directory within the container, such as:

.. code-block:: bash

   docker run -v /my/test/suite:/features mwhipple/brine:0.13-ruby

The ``CUCUMBER_OPTS`` environment variable can be used to pass additional arguments to
cucumber. The ``FEATURE`` environment variable specifies the container path to the
feature file if for some reason a value other than the default ``/features`` is desired.
