Brine
===

Cucumber DSL for testing REST APIs


Most of the non-trivial behavior is provided by modules which are attached to
the World object.

As an initial design principle, there is no defined coupling between the
modules: in cases where there are dependencies the steps code will
handle the appropriate injection of inter-module objects.
There may be a better, more ruby-ish way to approach this but
I'm scared of the god_object_through_including_every_module possibility
