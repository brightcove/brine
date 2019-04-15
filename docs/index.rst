###################
Brine Documentation
###################

A Cucumber based DSL for testing REST APIs.

******************************
How to Read This Documentation
******************************

Brine's documentation is broken into a few major sections where the
descriptions here should help indicate which section is the best
resource for a particular type of need. If there are questions
which are not answered after consulting the appropriate section of
documentation, then please file a
`documentation bug <https://github.com/brightcove/brine/issues/new?labels=bug,documentation>`_.

:ref:`toc-user-guide`
	The User Guide provides an introduction to the use and
	underlying concepts of Brine. The guide also includes
	a reference list of what is exposed by Brine.
	The User Guide therefore acts as a high level overview
	to the standard functionality provided by Brine.

:ref:`toc-specification`
	Brine specifications are the living, definitive reference for
	the Brine DSL, and should be able to answer any specific questions about
	the behavior of the provided DSL (or any other behavior which is not
	runtime-specific). The specification should therefore be able to answer
	any lower level questions about standard Brine behavior but is unlikely
	to provide guidance in terms of practical application of that functionality.

:ref:`toc-articles`
	Articles will be used to provide more targeted information about using
	Brine. This will include techniques, ideas, and practices around using Brine,
	how to use Brine with other technologies, and more in-depth explorations
	of specific use cases.

.. _toc-user-guide:

.. toctree::
   :maxdepth: 2
   :caption: User Guide

   introduction
   installation
   tutorial
   concepts
   traversal
   envvars
   step_reference

.. _toc-specification:

.. toctree::
   :caption: Specification

   specification

.. _toc-articles:

.. toctree::
   :caption: Articles

   articles/index

******************
Indices and tables
******************

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
