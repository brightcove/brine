Brine
===

> Cucumber DSL for testing REST APIs

Motivation
---
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

Sample Usage
---
The general usage pattern revolves around construction of a request
and performing assertions against the received response.

```
When the request body is:
  """
  {"first_name": "John",
   "last_name": "Smith"}
  """
And a POST is sent to `/users`
Then the response status equals `200`
And the response body includes the entries:
  | first_name | John  |
  | last_name  | Smith |
```

Disclaimer
---
Right now this project is new and features are being implemented as
needed rather than speculatively. Some of the info here may be more
optimistic than realistic until things are smoothed out or hopes abandoned.

Features
---

### Variable Binding/Expansion

In cases where dynamic data is in the response or is desired for the
request, then values can be bound to identifiers which can then be
expanded using [Mustache](mustache.github.io) templates in your
feature files.

### Type Transforms

Different types of data can be expressed directly in the feature files
or expanded into variables by using the appropriate syntax for that
type.

[Read More](https://github.com/brightcove/brine/wiki/Argument-Transforms)

### Resource Cleanup

Tests are likely to create resources which should then be cleaned up,
restoring the pre-test state of the system: steps to facilitate this
are provided.

### Authentication

Presently OAuth2 is supported to issue authenticated requests during a
test (likely using a feature `Background`).

### Request Construction and Response Assertion Step Definitions

The previous features combined with the library of provide steps should
cover all of the functionality needed to exercise and validate all of
the functionality exposed by your REST API.


Installation
---

Presently the gem for this project isn't being published anywhere:
primarily because tracking down a local gem repository seems scary. If
this project is open sourced then this will probably change but in the
meantime the project can be used off of GitHub by adding this to your
`Gemfile` and performing the usual `bundle install` dance:

```ruby
git 'git@github.com:brightcove/brine.git', :branch => 'master' do
  gem 'brine'
end
```

Specific branches and refs can be targetted as
documented [here](http://bundler.io/git.html). This should likely be
done in any cases where you're not actively tracking Brine and don't want
your tests to suddenly break because of changes to it.

Brine can then be "mixed in" to your project (which adds assorted
modules to the `World` and loads all the step definitions and other
Cucumber magic) by adding the following to your `support/env.rb` or
other ruby file:

```ruby
require 'brine'

World(brine_mix)
```

Select pieces can also be loaded (to be documented). With the above,
feature files should be able to be written and executed without
requiring any additional ruby code.

Questions? Comments?
---
Check out the [wiki](https://github.com/brightcove/brine/wiki) for more information
and search for related [issues](https://github.com/brightcove/brine/issues)
or open one for anything not documented or implemented elsewhere.
