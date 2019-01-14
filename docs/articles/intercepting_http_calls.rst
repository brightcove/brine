#######################
Intercepting HTTP Calls
#######################

*******
Context
*******

There may be cases where the request or reponse may need to be modified
in some way before or after transmission, for example to add a custom header
which is somehow specific to the testing configuration and therefore outside
of anything that belongs in the specification.

********
Solution
********

This can be done through the registration of custom Faraday middleware on
the Brine client. All of the registered middleware attaches
to the generated connection through an array of functions in
`requester.rb <https://github.com/brightcove/brine/blob/master/lib/brine/requester.rb>`_.
Each function accepts the connection object as its single parameter.
The array of functions is exposed as ``connection_handlers`` and can be modified
through getting that property from either the default ``World``
(for the default client) or from an appropriate ``ClientBuilder``
if creating custom clients and mutating it accordingly (setting the reference
is not suported).
You could just build your own client without the facilities provided by Brine.

******
Recipe
******

An example to add a custom header could be implemented as follows:

.. code-block:: ruby

   require 'faraday'
   class CustomHeaderAdder < Faraday::Middleware
     def initialize(app, key, val)
       super(app)
         @key = key
         @val = val
       end

       def call(env)
         env[:request_headers].merge!({@key => @val})
         @app.call(env)
       end
     end
   end

   ...

   connection_handlers.unshift(proc do |conn|
     conn.use CustomHeaderAdder, 'x-header', 'I am a test'
   end)


