##
# @file performing.rb
# Performing of of potentially deferred actions.
##

module Brine

  ##
  # A module supporting either immediate or defered evaluation of logic.
  ##
  module Performing

    ##
    # A passthrough performer which immediately invokes provided actions.
    #
    # This has no instance state and therefore a Flyweight could be used,
    # but too few instances are expected to warrant even the minor divergence.
    ##
    class ImmediatePerformer

      ##
      # Perform the provided actions immediately.
      #
      # @param [Proc] A thunk of actions to be performed.
      ##
      def perform(actions)
        actions.call
      end
    end

    ##
    # A Peformer which collects rather than evaluating actions.
    ##
    class CollectingPerformer

      ##
      # Construct an instance with an empty collection of actions.
      ##
      def initialize
        @actions = []
      end

      ##
      # Collect provided actions for later evaluation.
      #
      # @param [Proc] A thunk of actions to be performed.
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
    # The currently active Performer instance exposed as a property.
    #
    # The default implementation will be wired as needed upon first access.
    #
    # @return [Performer, #perform] The Performer to which actions will be sent.
    ##
    def performer
      @performer || reset_performer
    end

    ##
    # Reset the Performer instance to the default implementation.
    #
    # @return [Performer, #perform] The default implementation which will now be the `performer`.
    ##
    def reset_performer
      @performer = ImmediatePerformer.new
    end

    ##
    # Pass the actions to the current Performer instance.
    #
    # @param [Proc] The thunk of the actions to be performed.
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
    # The number of seconds between polling attempts.
    #
    # Can be provided by the `BRINE_POLL_INTERVAL_SECONDS` environment variable.
    # Defaults to `0.5`.
    #
    # @return [Number] The number of seconds to sleep between poll attempts.
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
    # @param [Number] seconds The period (in seconds) during which the block will be retried.
    # @param [Number] interval How long to sleep between polling attempts, defaults to `#poll_interval_seconds`.
    # @param [Block] The logic to retry within the defined period.
    # @return [Object] The result of the block if successfully evaluated.
    # @throws [Exception] The most recent exception thrown from the block if never successfully evaluated.
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
    # The duration in seconds for the given handle.
    #
    # Currently this only supports values provided through environment variables
    # of the format BRINE_DURATION_SECONDS_{handle}.
    #
    # @param[String] duration The handle/name of the duration whose length should be returned.
    # @return [Number] The number of seconds to poll for the requested duration.
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
