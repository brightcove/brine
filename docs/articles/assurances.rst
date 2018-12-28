#################################
Assure Required Data is Available
#################################

*******
Context
*******

Ideally all tests should be as self-contained and isolated as possible;
when writing functional tests, however, there are cases where this isn't
feasible or possible. In some cases a system depends on another external
system which is not a system that is under test and which (for whatever reason)
cannot be easily worked with. In white box testing such a system would likely be
represented by some form of test double, but this may be impractical and/or
undesirable when testing a deployed system.

An example of such a system is user/account management which often incurs
additional overhead to provision a new account. When testing a secured
system valid accounts are needed for representative testing, but provisioning
a new account may be difficult or outside the scope of the system that is being
actively tested. If tested functionality involves enacting account-wide changes
and the number of accounts is limited, then that is likely to unfortunately
prevent complete test isolation.

********
Solution
********

In such cases a standard solution is to designate certain resources to be
reused for certain tests. The term "assurances" is used here for verification
of such resources...primarily because it
starts with `a` which lends itself to relevant files being listed towards the
beginning alphabetically in a given directory.

The goal of assurances is to specify conditions which are expected before other
tests are to be run. Preferably the dependent tests should also explicitly
declare the dependency but a significant solution for that is not established.
Assurances therefore validate that preconditions are met; ideally if such
preconditions can be established idempotently then the assurances can do so
before the validation.

Assurances are NOT Tests
========================

**Assurances validate a state which is desired to be consistently retained
within the system rather than being changed**. This means that they should _not_
be used for tests as that would require state changes, nor should they clean up
after themselves (as that would also imply a state change). If assurances are
configured for a system which should also be tested, then appropriate tests
should exist (including those that may validate any behavior relied upon by
the assurance).

Consequences
============

As mentioned previously assertions help in cases where tests cannot be fully
isolated, and therefore some known state must be established and reused across
tests (and such state should *not* change). A practical reason for this is to
allow for overlapping test executions.
If tests are not fully isolated and test runs overlap whil state is being changed
then tests may fail non-deterministically due to one test run pulling the state
out from another. This in the simplest form can be a nuisance but it also
effectively precludes the ability to speed up test runs through the use of
parallelism/asynchronicity.

.. todo:: Enumerate drawbacks

******
Recipe
******

This can be done using standard cucumber tags. Assurances can be defined in
designated samp:`assure_{description}.feature` files where each Feature is appropriately
tagged:

.. code-block:: gherkin

   @assure
   Feature: Some preconditions are verified...

And then a Rake or similar task can be added to run those tagged features:

.. code-block:: ruby

   Cucumber::Rake::Task.new(:assure) do |t|
     t.cucumber_opts = "#{ENV['CUCUMBER_OPTS']} --tags @assure"
   end

The task that runs the other tests then depends on the assure task:

.. code-block:: ruby

   task :invoke_cuke => [:assure] do
     #Run cucumber, potentially in parallel and likely with --tags `@assure`
   end

This approach tests preconditions and will avoid running the rest of the tests
if they are not (relying on standard Rake behavior). The assurances can also be
run with different Cucumber behavior so that the full test suite can be more
stochastic (randomized/non-serialized) while the assurances can be more
controlled.

