.. _traversal:

#########
Traversal
#########

The language exposed by Brine is flat but the data returned by the server is
likely to include deeper data structures such as objects and collections. To
allow selection within such structures a :keyword:`traversal` language is embedded within
some steps which will be indicated by the use of the ``TRAVERSAL`` placeholder.

The traversal language consists of a selected subset of
`JsonPath <http://goessner.net/articles/JsonPath/>`_.

***************
JsonPath Subset
***************

A subset of JsonPath functionality will be officially supported that is
believed to cover all needed use cases without requiring deep familiarity
with JsonPath. This may lead to more numerous simple steps in place of
fewer steps that use unsupported expressions. The simpler steps should
result in specifications that are clearer: both in terms of being more
readable and also having more precisely defined logic. Brine is designed
to be ported to multiple runtimes and only the selected subset will be
supported across those runtimes (which should facilitate porting to any
runtimes for which a more complete JsonPath implementation does not exist).
Any expressions not listed here will not be disallowed and will work
if handled by the JsonPath implementation, but are not officially supported.

***********
Cardinality
***********

Each traversal expression will select *all* matching nodes which is therefore
represented as a collection. Often, however, only a single node is expected or
desired. Therefore the traversal expression will also be accompanied by a phrase
which defines the expected cardinality, normally ``child`` and ``children``.
``children`` will *always* return an array while ``child`` will return what would be the
first element in that array. ``child`` should be used when accessing a specific node within
the tree, while ``children`` should be used for a query across multiple nodes
(such as testing the value of a field for every element in a collection).

***********
Expressions
***********

.. glossary::

   :samp:`.{KEY}`
	Access the child named :samp:`{KEY}` of the target node.
	The leading ``.`` can be omitted at the start of an expression.

   :samp:`.[{INDEX}]`
	Access the element of the array at index :samp:`{INDEX}`.

   :samp:`.[{FROM}:{TO}]`
	Access a slice of the array containing the elements at index
	:samp:`{FROM}` through :samp:`{TO}` (including both limits).
