##
# @file cleaner_upper.rb
# Clean up resources created during test run.
#
# Will issue DELETE call for all tracked URLs which will normally be triggered
# in a hook.
#
# The present approach for this is to explicitly track created resources to
# which DELETE calls will be sent. Cleaning up of resources will be given some
# further attention in the future, but this functionality should be preserved.

##
# A command object for the delete which will be executed as part of cleaning up.
class DeleteCommand

  ##
  # Construct a command with the required paramters to perform the delete.
  #
  # @param client The Faraday client which will send the delete message.
  # @param path The path of the resource to be deleted.
  # @param oks The response status codes which will be considered successful.
  # @param attempts The number of times this command should be tried,
  # retrying if an unsuccessful status code is received.
  def initialize(client, path, oks: [200,204], attempts: 3)
    @client = client
    @path = path
    @oks = oks
    @attempts = attempts
  end

  ##
  # Issue the delete based on the parameters provided during construction.
  #
  # @returns true if a successful response is obtained, otherwise false.
  def cleanup
    while @attempts > 0
      begin
        resp=@client.delete(@path)
        return true if @oks.include?(resp.status)
      rescue ex
        puts "WARNING: #{ex}"
      end
      @attempts -= 1
    end
    puts "ERROR: Could not DELETE #{@path}"
    false
  end
end

##
# A mixin which provides resource cleanup.
#
# Exposes methods to keep a stack of DeleteCommands corresponding to each
# created resource which are then popped and invoked to perform the cleanup.
#
# The LIFO behavior is adopted as it is more likely to preserve integrity,
# such as removing children added to parents or similar dependencies.
module CleanerUpper

  ##
  # Set the Faraday HTTP client object used to issue DELETE calls.
  #
  # The client provided will be subsequently used to create DeleteCommands.
  # This can be called multiple times where each DeleteCommand will use the
  # most recently set value. In most use cases this will also be the client
  # used to issue the creation requests and could therefore be passed to this
  # method prior to use.
  #
  # @param client - The client to use to DELETE subsequently tracked resources.
  def set_cleaning_client(client)
    @client = client
  end

  ##
  # Record resource to be later cleaned (pushes a DeleteCommand).
  #
  # @param path - The path for the created resource, will be issued a DELETE.
  def track_created_resource(path)
    created_resources << DeleteCommand.new(@client, path)
  end

  ##
  # Clean recorded resources (normally after a test run).
  def cleanup_created_resources
    created_resources.reverse.each{|it| it.cleanup}
  end

  private

  ##
  # The array which serves as the stack of DeleteCommands.
  #
  # Works as a "module provided property" which is a name I
  # may have just made up.
  #
  # TODO: Find proper term for module provided property
  # TODO: The name of this property seems sloppy as it contains commands.
  def created_resources
    @created_resources ||= []
  end
end
