##
# @file cleaning_up.rb
# Clean up resources created during test run.
#
# Will issue DELETE call for all tracked URLs which will normally be triggered
# in a hook.
#
# The present approach for this is to explicitly track created resources to
# which DELETE calls will be sent. Cleaning up of resources will be given some
# further attention in the future, but this functionality should be preserved.
##

module Brine

  ##
  # A module providing resource cleanup.
  #
  # Exposes methods to keep a stack of DeleteCommands corresponding to each
  # created resource which are then popped and invoked to perform the cleanup.
  #
  # LIFO behavior is adopted as it is more likely to preserve integrity,
  # such as removing children added to parents or similar dependencies.
  ##
  module CleaningUp

    ##
    # A command object for the delete which will be executed as part of cleaning up.
    #
    # The command will be retried a specified number of times if an unsuccessful status code is received.
    ##
    class DeleteCommand

      ##
      # Construct a command with the required paramters to perform the delete.
      #
      # @param [Faraday::Connection, #delete] client The Faraday client which will send the delete message.
      # @param [String] path The path of the resource to be deleted.
      # @param [Array<Integer>] oks The response status codes which will be considered successful.
      # @param [Integer] attempts The number of times this command should be tried.
      ##
      def initialize(client, path, oks: [200,204], attempts: 3)
        @client = client
        @path = path
        @oks = oks
        @attempts = attempts
      end

      ##
      # Issue the delete based on the parameters provided during construction.
      #
      # @return [Boolean] true if a successful response is obtained, otherwise false.
      ##
      def cleanup
        for _ in 1..@attempts
          begin
            resp=@client.delete(@path)
            return true if @oks.include?(resp.status)
          rescue Exception => ex
            STDERR.puts "WARNING: #{ex}"
          end
        end
        STDERR.puts "ERROR: Could not DELETE #{@path}"
        false
      end
    end

    ##
    # Set the Faraday HTTP client object used to issue DELETE calls.
    #
    # The client provided will be subsequently used to create DeleteCommands.
    # This can be called multiple times where each DeleteCommand will use the
    # most recently set value. In most use cases this will also be the client
    # used to issue the creation requests and could therefore be passed to this
    # method prior to use.
    #
    # @param [Faraday::Connection, #delete] client The client to use to DELETE subsequently tracked resources.
    ##
    def set_cleaning_client(client)
      @client = client
    end

    ##
    # Record resource to be later cleaned (pushes a DeleteCommand).
    #
    # @param [String] path The path for the created resource; will be issued a DELETE.
    ##
    def track_created_resource(path)
      cleanup_commands << DeleteCommand.new(@client, path)
    end

    ##
    # Clean recorded resources (normally after a test run).
    #
    # @return [Boolean] true if all commands succeeded successfully, otherwise false.
    ##
    def cleanup_created_resources
      # Avoid the use of any short circuiting folds.
      cleanup_commands.reverse.inject(true) { |accum, x| accum && x.cleanup }
    end

    private

    ##
    # The array which serves as the stack of DeleteCommands.
    #
    # Provides the property mixed in by the module.
    #
    # @return [Array<DeleteCommand>]
    ##
    def cleanup_commands
      @cleanup_commands ||= []
    end

  end

  ##
  # Mix the CleaningUp module functionality into the main Brine module.
  ##
  include CleaningUp
end
