##
# @file performing.rb
# Perform potentially deferred actions.
##
module Brine

  ##
  # Support either immediate or defered evaluation of logic.
  ##
  module Performing

    ##
    # Immediately invoke provided actions.
    #
    # This has no instance state and therefore a Flyweight could be used,
    # but too few instances are expected to warrant even the minor specialization.
    ##
    class ImmediatePerformer

      ##
      # Perform the provided actions immediately.
      #
      # @param [Proc] Provide actions to be performed.
      ##
      def perform(actions)
        actions.call
      end
    end

    ##
    # Collect actions to be evaluated later.
    ##
    class CollectingPerformer

      ##
      # Construct an instance with an empty collection of actions.
      ##
      def initialize
        @actions = []
      end

      ##
      # Collect provided actions.
      #
      # @param actions [Proc] Provide actions to collect.
      ##
      def perform(actions)
        @actions << actions
      end

      ##
      # Evaluate the collected actions in sequence.
      ##
      def evaluate
        @actions.each { |it| it.call }
      end

    end

    ##
    # Expose the currently active Performer as a property.
    #
    # The default implementation will be wired as needed upon first access.
    #
    # @return [Performer, #perform] Return the Performer to which actions will be sent.
    ##
    def performer
      @performer || reset_performer
    end

    ##
    # Reset the Performer instance to the default implementation.
    #
    # @return [Performer, #perform] Return the default implementation which will now be the active Performer.
    ##
    def reset_performer
      @performer = ImmediatePerformer.new
    end

    ##
    # Pass the actions to the active Performer instance.
    #
    # @param actions [Proc] The actions to pass to the Performer.
    ##
    def perform(&actions)
      performer.perform(actions)
    end

    ##
    # Begin collecting, rather than immediately performing, actions.
    ##
    def collect_actions
      @performer = CollectingPerformer.new
    end

    ##
    # Determine the number of seconds between polling attempts.
    #
    # This can be provided by the `BRINE_POLL_INTERVAL_SECONDS` environment variable
    # (defaults to `0.5`).
    #
    # @return [Number] Return the number of seconds to sleep between poll attempts.
    ##
    def poll_interval_seconds
      ENV['BRINE_POLL_INTERVAL_SECONDS'] || 0.25
    end

    ##
    # Retry the provided block for the specified period.
    #
    # If the provided block is evaluated successfully the result
    # will be returned, if any exception is thrown it will be
    # retried until the period elapses.
    #
    # @param seconds [Number] Define the period (in seconds) for which the block will be retried.
    # @param interval [Number] Define how long to sleep between polling attempts (defaults to `#poll_interval_seconds`).
    # @param [Block] Provide the logic to retry within the defined period.
    # @return [Object] The result of the block if successfully evaluated.
    # @throws [Exception] Re-throws the most recent exception thrown from the block if never successfully evaluated.
    ##
    def poll_for(seconds, interval=poll_interval_seconds)
      failure = nil
      quit = Time.now + seconds
      while (Time.now < quit)
        begin
          return yield
        rescue Exception => ex
          failure = ex
          sleep interval
        end
      end
      raise failure
    end

    ##
    # Retrieve the duration in seconds for the given handle.
    #
    # Currently this only supports values provided through environment variables
    # of the format BRINE_DURATION_SECONDS_{handle}.
    #
    # @param duration [String] Identify the duration whose length should be returned.
    # @return [Number] Return the number of seconds defined for the requested duration.
    ##
    def retrieve_duration(duration)
      if ENV["BRINE_DURATION_SECONDS_#{duration}"]
        ENV["BRINE_DURATION_SECONDS_#{duration}"].to_f
      else
        STDERR.puts("Duration #{duration} not defined")
      end
    end

  end

  ##
  # Mix the Performing module functionality into the main Brine module.
  ##
  include Performing
end

require 'brine/selecting.rb'

##
# Collect actions rather than immediately evaluating them.
##
When('actions are defined such that') do
  collect_actions
end

##
# Evaluate collected actions for the provided period.
#
# This will pass if any evaluation is successful within the specified time.
#
# @param negated [Boolean] Specify whether the assertion should be expected to fail.
# @param period [Object] Specify the period length as returned by #retrieve_duration.
##
Then('the actions are{maybe_not} successful within a {grave_param} period') do |negated, period|
  method = negated ? :to : :to_not
  expect do
    poll_for(retrieve_duration(expand(period, binding))) do
      performer.evaluate
    end
  end.send(method, raise_error)
  reset_performer
end
