#####################
Environment Variables
#####################

The primary channel for tuning Brine's behavior is through environment variables.
Environment variables are used since they can be consistently used across a wide
range of technologies and platforms, and align with the ideas espoused by
`The Twelve Factor App <https://12factor.net/config>`_.

.. envvar:: BRINE_ROOT_URL

   The location of the default API being tested. Requests will be sent to URLs of the pattern
   :samp:`{${BRINE_ROOT_URL}}{${PATH}}` where :samp:`{PATH}` is provided by the feature steps. Including
   path segments as prefix in ``BRINE_ROOT_URL`` is currently **not** supported, only non-path
   components (:samp:`{scheme}://{hostname}[:{port}]`). For example if an API has a context root path of
   ``v1`` where all paths are similar to ``http://www.example.com/v1/...``, then ``v1`` cannot be
   added to ``BRINE_ROOT_URL`` and **must** be included in each feature step (or other workaround
   implemented). This has not yet presented itself as a problem; if it does then please file an
   `issue`_ and a solution can be implemented. A caveat to considering this an issue is that it may
   lead to specifications that are less expressive; any path prefix is likely be necessary for calling
   the API and implicit prefixes may lead to the specification becoming a less useful definition of
   how to use the API (simple, consistent usage is unlikely to cause this, but pursuing DRY relative
   paths for disparate prefixes is likely to bury value).

.. envvar:: BRINE_LOG_HTTP

   Output HTTP traffic to stdout. Any truthy value will result in request and
   response metadata being logged, a value of :kbd:`DEBUG` (case insensitive) will
   also log the bodies.

.. envvar:: BRINE_LOG_BINDING

   Log values as they are assigned to variables in Brine steps.

.. envvar:: BRINE_LOG_TRANSFORMS

   Log how parameter inputs are being transformed.

.. envvar:: BRINE_DURATION_SECONDS_${duration}

   How long in seconds :ref:`polling` will be done when :samp:`{duration}` is specified.

.. envvar:: BRINE_POLL_INTERVAL_SECONDS

   The amount of time to wait between attempts when :ref:`polling`.
