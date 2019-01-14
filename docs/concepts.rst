########
Concepts
########

************************
The use of :samp:`\``\ s
************************

Backticks/grave accents are used as *parameter delimiters*. It is perhaps
most helpful to think of them in those explicit terms rather than thinking of
them as an alternate *quote* construct. In particular quoting implies that the
parameter value is a string value, while the step transforms allow for
alternative data types.

:samp:`\``\ s were chosen as they are less common than many other syntactical
elements and also allow for the use of logically significant
quoting within paremeter values while hopefully avoiding the need for escape
artistry (as used for argument transforms).

***********************
Selection and Assertion
***********************

As tests are generally concerned with performing assertions, a testing DSL
should be able to express the variety of assertions that may be needed. Because
these are likely to be numerous, it could easily lead to duplicated logic or
geometric growth of code due to the combinations of types of assertions and the
means to select the inputs for the assertion.

To avoid this issue the concepts of selection and assertion are considered
separate operations in Brine. Internally this corresponds to two steps:

#. Assign a selector
#. Evaluate the assertion against the selector

In standard step use this will still be expressed as a single step,
and dynamic step definitions are used to split the work appropriately.

For example the step:

.. code-block:: gherkin

   Then the value of the response body is equal to `foo`

Will be split where the subject of the step (``the value of the response body``)
defines the selector and the predicate of the step
``is equal to `foo``` defines the assertion (which is translated to a
step such as ``Then it is equal to `foo```).

The result of this is that the assertion steps will always follow a pattern
where the subject resembles ``the value of ...`` and the predicate always
resembles ``is ...``. Learning the selection phrases and the assertion phrases
and combining them should be a more efficient and flexible way to become
familiar with the language instead of focusing on the resulting combined steps.

The chosen approach sacrifices eloquence for the sake of consistency.
The predicate will always start with a variation of "to be" which can lead to
awkward language such as ``is including`` rather than simply ``includes``.
The consistency provides additional benefits such as consistent modification:
for instance negation ca always be done using the "to be" verb (such as ``is not``
rather than working out the appropriate phrasing for a more natural sounding step
(let alone the logic).

One of the secondary goals of this is that assertion step definitions should
be very simple to write and modifiers (such as negation) should be provided for
free to those definitions.
As assertion definitions are likely to be numerous and potentially customized,
this should help optimize code economy.

Selection Modifiers
===================

To pursue economical flexibility Brine steps attempt to balance step definitions
which accommodate variations while keeping the step logic and patterns fairly
simple. Selection steps in particular generally accept some parameters that
affect their behavior. This allows the relatively small number of selection
steps to provide the flexibility to empower the more numerous assertion steps.

Traversal
---------

Selection steps can generally target the root of the object specified (such as the
response body) or some nodes within the object if it is a non-scalar value
(for instance a child of the response body).
This is indicated in the :ref:`step_reference` by the :samp:`{[TRAVERSAL]}` placeholder.
:samp:`child {EXPRESSION}` or :samp:`children {EXPRESSION}` can optionally be inserted
at the placeholder to select nested nodes as described in :ref:`traversal`.

Negation
--------

The selectors also currently handle negation of the associated assertions.
This is potentially counter-intuitive but as previously mentioned the intent is
that this should ease the creation of assertions. If negation is added to a
selector that it is expected that the assertion will *fail*.

Negation will indicated in the :ref:`step_reference` by the presence of a
`[not]` or semantically equivalent placeholder. To negate the step the
literal text within the placeholder should be included at the indicated position.

.. note::

   The implementation of negation is planned to be changed in a future version
   but all any existing steps will be supported at least through one major version
   (i.e. the implementation may change for version 2 but all steps will be supported
   until at least version 3).

.. _handling nested elements:

************************
Handling Nested Elements
************************

Using brine should provide easy to undertand tests. Given:

.. code-block:: gherkin

   When the request body is assigned:
     """
     {"name":"Jet Li",
      "skills":"Being the one, Multiverse-homicide"}
     """
   And a POST is sent to `/people`

A check on skills could follow up, with the response returning the created
object inside an object with ``data`` and ``links`` sub-objects (Hypermedia API):

.. code-block:: gherkin

   Then the value of the response status is equal to `201`
   And the value of the response body child `data.skills` is a valid `Array`
   And the value of the response body child `data.skills is including:
     """
     "Multiverse-homicide"
     """
   And the value of the response body child `data.skills is including:
     """
     "Being the one"
     """

The above example uses child comparison to type as well as value, verifies
multiple elements from PUT body. This can be useful if your response contains
HATEOAS (Hypermedia As The Engine Of Application State) Links. The end goal is
that anyone reading the specification will be able to ascertain without
cucumber or DSL knowledge what the intent is.

If order can be guaranteed then checks could be combined into a simpler format:

.. code-block:: gherkin

   Then the value of the response status is equal to `201`
   And the value fo the response body child `data.skills` is a valid `Array`
   And the value of the response body child `data` is including:
     """
     {"skills":["Being the one", "Multiverse-homicide"]}
     """

.. todo:: This should also be supported through pending set equality assertions.

On a more serious note, the above could also be used to verify business logic
such as for medical professionals working with large insurers or healthcare
the line-items usually have to be sorted by price descending.

.. _resource_cleanup:

****************
Resource Cleanup
****************

All test suites should clean up after themselves as a matter of hygiene and to
help enforce test independence and reproducibility. This is particularly
important for this library given that the systems under test
are likely to remain running; accumulated uncleaned resources are at best a
nuisance to have to weed through and at worst can raise costs due to
heightened consumption of assorted resources (unlike more ephemeral test
environments).

Brine therefore provides mechanisms to assist in cleaning up those resources
which are created as part of a test run. A conceptual hurdle for this type of
functionality is that it is very unlikely to be part of the feature that is
being specified, and therefore should ideally not be part of the specification.
Depending on the functionality (and arguably the
`maturity <https://www.martinfowler.com/articles/richardsonMaturityModel.html>`_)
of the API, most or all of the cleanup can be automagically done based on
convention. There are tentative plans to support multiple techniques for
cleaning up resources based on how much can be implicitly
ascertained...though presently there exists only one.

Step indicating resource to DELETE
==================================

If the API supports DELETE requests to remove created resources but it is either
desirable or necessary to specify what those resource PATHS are, a step can be
used to indicate which resources should be DELETEd upon test completion.

.. seealso::

   Steps
	:ref:`step_reference_resource_cleanup`
