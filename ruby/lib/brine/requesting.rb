##
# @file requesting.rb
# Request construction and response storage.
##

module Brine

  ##
  # Module in charge of constructing requests and saving responses.
  ##
  module Requesting
    require 'faraday_middleware'
    require 'brine/client_building'

    ##
    # The root url to which Brine will send requests.
    #
    # This will normally be the value of ENV['BRINE_ROOT_URL'],
    # and that value should be directly usable after older
    # ENV['ROOT_URL'] is end-of-lifed (at which point this can be removed).
    #
    # @brine_root_url is used if set to allow setting this value more programmatically.
    #
    # @return [String] The root URL to use or nil if none is provided.
    ##
    def brine_root_url
      if @brine_root_url
        @brine_root_url
      elsif ENV['BRINE_ROOT_URL']
        ENV['BRINE_ROOT_URL']
      elsif ENV['ROOT_URL']
        deprecation_message('1.0', 'ROOT_URL is deprecated, replace with BRINE_ROOT_URL') if ENV['ROOT_URL']
        ENV['ROOT_URL']
      end
    end

    ##
    # Normalize an HTTP method for the HTTP client library (to a lowercased symbol).
    #
    # @param [String] method A text representation of the HTTP method.
    # @return [Symbol] A representation of `method` usable by the HTTP client library.
    ##
    def parse_method(method)
      method.downcase.to_sym
    end

    ##
    # Set the client which will be used to send HTTP requests.
    #
    # This will generally be a connection as created by the ClientBuilding module.
    #
    # @param [Faraday::Connection, #run_request] client The client which will be used to issue HTTP requests.
    ##
    def set_client(client)
      @client = client
    end

    ##
    # The currently active client which will be used to issue HTTP calls.
    #
    # This will be initialized as neded on first access
    # to a default client constructed by the ClientBuilding module.
    #
    # @return [Faraday::Connection, #run_request] The currently active client object.
    ##
    def client
      @client ||= client_for_host(brine_root_url)
    end

    ##
    # Clear any previously built request state and set defaults.
    #
    # This should be called upon request completion or when constructing a new
    # request so no extant state inadvertently pollutes the new construction.
    ##
    def reset_request
      @params = @headers = @body = nil
    end

    ##
    # Store the provided body in the request being built.
    #
    # This will override any previous body value.
    #
    # @param [Object] The new data to be placed in the request body.
    ##
    def set_request_body(obj)
      @body = obj
    end

    ##
    # Send a `method` request to `url` including any current builder options and store response.
    #
    # The response will be available as the `#response` property.
    #
    # For requests such as simple GETs that only require a url this method may
    # be self-contained; for more complex requests the values collected through
    # request building are likely required. Any data present from the builder
    # methods will always be inclued in the request and therefore such data should
    # be cleared using `#reset_request` if it is not desired.
    #
    # @param [Symbol] method The client friendly representation of the HTTP method for the request
    #                        (@see #parse_method).
    # @param [String] url The url to which the request will be sent.
    ##
    def send_request(method, url)
      @response = client.run_request(method, url, @body, headers) do |req|
        req.params = request_params
      end
    end

    ##
    # The response for the last sent request.
    #
    # @return [Faraday::Response] The most recent response.
    ##
    def response
      @response
    end

    ##
    # The headers for the request currently being built.
    #
    # Will be initialized as needed on first access,
    # with a default specifying JSON content-type.
    #
    # @return [Hash] The headers to use for the constructed request.
    ##
    def headers
      @headers ||= {content_type: 'application/json'}
    end

    ##
    # Set the specified header to the provided value.
    #
    # @param [String] k The name of the header whose value will be set.
    # @param [Object] v The value to set for the specified header.
    #                   This should normally be a String, but some other types may work.
    ##
    def set_header(k, v)
      headers[k] = v
    end

    ##
    # The query parameters which will be attached to the constructeed request.
    #
    # Will be initialized to an empty hash as needed upon first access.
    #
    # @return [Hash] The query parameters to use for request construction.
    ##
    def request_params
      @request_params ||= {}
    end

    ##
    # Assign the provided value to the specified request query parameter.
    #
    # @param [String] k The name of the query parameter whose value is being assigned.
    # @param [Object] v The value to assign the query parameter (normally a String).
    ##
    def set_request_param(k, v)
      request_params[k] = v
    end

  end

  ##
  # Mix the Requesting module functionality into the main Brine module.
  ##
  include Requesting
end
