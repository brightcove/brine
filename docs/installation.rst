############
Installation
############

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
