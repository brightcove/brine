########
Tutorial
########

To demonstrate typical usage of Brine,
let's write some tests against http://myjson.com/api
(selected fairly arbitrarily from the list at
https://github.com/toddmotto/public-apis).

======================
Setting BRINE_ROOT_URL
======================

Brine expects steps to use relative URLs. The feature files specify
the behavior of an API (or multiple APIs), while the root of the
URLs define where that API is, so this is a natural mapping.
More practically, when developing an API it's likely to
be promoted across various environments such as
local, qa, stage, and production so having a parameterized root for
the URLs eases this while encouraging inter-environment consistency.

For simple cases where all tests are to be run against the same root,
the root url can be specified with the environment variable
:envvar:`BRINE_ROOT_URL`.

This can be specified when running :term:`Cucumber` with a command such as:

.. code-block:: shell

   BRINE_ROOT_URL=https://api.myjson.com/ cucumber

...or this can be managed as part of a :term:`Rake` task such as:

.. code-block:: ruby

   Cucumber::Rake::Task.new do
     ENV['BRINE_ROOT_URL'] = 'https://api.myjson.com/'
   end

...or by any other means that populates the environment appropriately.

A personally preferred approach is to have per-environment make files and
including the desired file(s) into the main file.

===========
A Basic GET
===========

Most tests will involve some form of issueing requests and performing assertions
on the responses. Let's start with a simple version of that pattern,
testing the response status from a GET request.

.. literalinclude:: ../tutorial/missing.feature
   :language: gherkin

===============
A Write Request
===============

For POST, PATCH, and PUT requests you'll normally want to include a request body.
To support this, additional data can be added to the rquess before they are sent.

.. literalinclude:: ../tutorial/post_status.feature
   :language: gherkin

.. seealso::
   Steps
	:ref:`step_reference_request_construction`

========================
Test Response Properties
========================

http://myjson.com/api returns the link to the created resource which is based
off of a generated it. That means the exact response cannot be verified, but instead
property based testing can be done to verify that the data is sande and therefore
likely trustworthy. In this case we can check that the ``uri`` response child matches
the expected pattern.

.. literalinclude:: ../tutorial/post_matching.feature
   :language: gherkin

.. ===================
   Known Response Data
   ===================

   One of the simplest and most obvious things to test for is that the response
   contains data for which exact values are expected. Continuing from above we can
   check that the respons ebody returns the fields that we provided.

   .. literalinclude:: ../tutorial/post_including.feature
      :language: gherkin
