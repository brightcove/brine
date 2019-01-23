.. _step_reference:

##############
Step Reference
##############

.. _step_reference_request_construction:

********************
Request Construction
********************

:ref:`Specification <spec_request_construction>`

The requests which are sent as part of a test are constructed using a
`builder <https://en.wikipedia.org/wiki/Builder_pattern>`_.

.. glossary::

   :samp:`When a {METHOD} is sent to \`{PATH}\``
	As every request to a REST API is likely to have a significant
	HTTP :samp:`{METHOD}` and :samp:`{PATH}`, this step is considered
	required and is therefore used to send the built request.
	This should therefore be the *last* step for any given request
	that is being built.

   :samp:`When the request body is assigned`
	The multiline content provided will be assigned to the body of the request.
	This will normally likely be the JSON representation of the data.

   :samp:`When the request query parameter \`{PARAMETER}\` is assigned \`{VALUE}\``
	Assign :samp:`{VALUE}` to the request query parameter :samp:`{PARAMETER}`.
	The value will be URL encoded and the key/value pair appended to the URL
	using the appropriate ``?`` or ``&`` delimiter. The order of the parameters in
	the resulting URL should be considered undefined.

   :samp:`When the request header \`{HEADER}\` is assigned \`{VALUE}\``
	Assign :samp:`{VALUE}` to the request header :samp:`{HEADER}`.
	Will overwrite any earlier value for the specified header,
	including default values or those set in earlier steps.

.. _step_reference_resource_cleanup:

****************
Resource Cleanup
****************

:ref:`Specification <spec_resource_cleanup>`

.. seealso::

   Concept
	:ref:`resource_cleanup`

.. glossary::

   :samp:`When a resource is created at \`{PATH}\``
	Mark :samp:`{PATH}` as a resource to DELETE after the test is run.

.. _step_reference_assignment:

**********
Assignment
**********

:ref:`Specification <spec_assignment>`

.. glossary::

   :samp:`When \`{IDENTIFIER}\` is assigned \`{VALUE}\``
	Assigns :samp:`{VALUE}` to :samp:`{IDENTIFIER}`.

   :samp:`When \`{IDENTIFIER}\` is assigned a random string`
	Assigns a random string (UUID) to :samp:`{IDENTIFIER}`.
	This can be useful to assist with test isolation.

   :samp:`When \`{IDENTIFIER}\` is assigned a timestamp`
	Assigns to :samp:`IDENTIFIER` a timestamp value representing the instant
	at which the step is evaluated.

   :samp:`When \`{IDENTIFIER}\` is assigned the response \`{|response_attribute|}\` {[TRAVERSAL]}
	Assigns to :samp:`IDENTIFIER` the value extracted from the specified response attribute
	(at the optional traversal path).

.. _step_reference_selection:

*********
Selection
*********

:ref:`Specification <spec_selection>`

.. seealso::

   Selection and Assertion
	:ref:`selection_and_assertion`

.. glossary::

   :samp:`Then the value of the response {|response_attribute|} {[TRAVERSAL]} is {[not]}`
	Select the specified response attribute (at the optional traversal path)
	of the current HTTP response.

   :samp:`Then the value of the response {|response_attribute|} {[TRAVERSAL]} does {[not]} have any element that is``
	Select any (at least one) element from the structure within the specified response attribute
	(at the optional traversal path).

   :samp:`Then the value of the {|response_attribute|} {[TRAVERSAL]} has elements which are all`
	Select all elements from the structure within the specified response attribute (at the optional traversal path).


.. _step_reference_assertion:

*********
Assertion
*********

:ref:`Specification <spec_assertion>`

.. seealso::

   Selection and Assertion
	:ref:`selection_and_assertion`

.. glossary::

   :samp:`Then it is equal to \`{VALUE}\``
	Assert that the selected value is equivalent to :samp:`{VALUE}`.

   :samp:`Then it is matching \`{VALUE}\``
	Assert that the selected value matches the regular expression
	:samp:`{VALUE}`.

   :samp:`Then it is including `\{VALUE}\``
	Assert that the selected value includes/is a superset of
	:samp:`{VALUE}`.

   :samp:`Then it is empty`
	Assert that the selected value is empty or null.
	Any type which is not testable for emptiness
	(such as booleans or numbers) will always return false.
	Null is treated as an empty value so that this assertion can
	be used for endpoints that return null in place of empty collections;
	non-null empty values can easily be tested for using a step conjoined
	with this one.

   :samp:`Then it is of length \`{VALUE}\``
	Assert that the value exposes a length attribtue and the value of that
	attribute is :samp:`{VALUE}`.

   :samp:`Then it is a valid \`{TYPE}\``
	Assert that the selected value is a valid instance of a :samp:`{TYPE}`.
	Presently this is focused on standard data types (initially based on
	those specified by JSON), but it is designed to handle user specified
	domain types pending soe minor wiring and documentation.
	The current supported types are:

	- ``Object`` - JSON style object/associative array
	- ``String``
	- ``Number``
	- ``Integer``
	- ``Array``
	- ``Boolean``

.. |response_attribute| replace:: body|status|headers

