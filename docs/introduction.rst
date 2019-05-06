############
Introduction
############

**********
Motivation
**********

REpresentational State Transfer APIs expose their functionality
through combinations of fairly coarse primitives that generally
revolve around the use of transferring data in a standard exchange
format (such as JSON) using HTTP methods and other aspects of the very
simple HTTP protocol. Tests for such an API can therefore be defined
using a domain specific language (DSL) built around those higher level
ideas rather than requiring a general purpose language (the equivalent
of scripted `curl` commands with some glue code and assertions).
This project provides such a DSL by using select libraries
integrated into Cucumber, where Cucumber provides a test-oriented
framework for DSL creation.

************
Sample Usage
************

The general usage pattern revolves around construction of a request
and performing assertions against the received response.

.. code-block:: gherkin

   When the request body is assigned:
     """
     {"first_name": "John",
      "last_name": "Smith"}
     """
   And a POST is sent to `/users`
   Then the value of the response status is equal to `200`
   And the value of the response body is including:
     """
     {"first_name": "John",
      "last_name": "Smith"}
     """

************
Key Features
************

Variable Binding/Expansion
	In cases where dynamic data is in the response or is desired for the
	request, then values can be bound to identifiers which can then be
	expanded using `Mustache <http://mustache.github.io>`_ templates in
	your feature files.

Type Transforms
	Different types of data can be expressed directly in the feature files
	or expanded into variables by using the appropriate syntax for that type.

Type Coercion
	Related to transforms, a facility ito coerce types is also provided.
	This allows more intelligent comparison of inputs which have been transformed
	to a richer data type with those that have not been transformed (normally strings).
	As an example, comparing a date/time value with a string will attempt to parse
	the string to a date/time so shtat the values can be compared using the proper
	semantics.

:ref:`resource_cleanup`
	Tests are likely to create resources which should then be cleaned up,
	restoring the pre-test state of the system.
	Steps to facilitate this are provided.

Authentication
	Presently OAuth2 is supported to issue authenticated requests during a
	test (likely using a feature :keyword:`Background`).

Request Construction and Response Assertion Step Definitions
	The previous features combined with the library of provided steps should
	cover all of the functionality needed to exercise and validate all of
	the functionality exposed by your REST API.
