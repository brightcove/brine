##
# @file requesting.rb
# Provide request construction and response storage.
##
module Brine

  ##
  # Support constructing requests and saving responses.
  ##
  module Requesting
    require 'faraday_middleware'
    require 'brine/client_building'

    ##
    # Retrieve the root url to which Brine will send requests.
    #
    # This will normally be the value of ENV['BRINE_ROOT_URL'],
    # and that value should be directly usable after older
    # ENV['ROOT_URL'] is end-of-lifed (at which point this can be removed).
    #
    # @brine_root_url is used if set to allow setting this value more programmatically.
    #
    # @return [String] Return the root URL to use or nil if none is provided.
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
    # @param method [String] Provide a text representation of the HTTP method.
    # @return [Symbol] Return `method` in a form potentially usable by the HTTP client library.
    ##
    def parse_method(method)
      method.downcase.to_sym
    end

    ##
    # Set the client which will be used to send HTTP requests.
    #
    # This will generally be a connection as created by the ClientBuilding module.
    #
    # @param client [Faraday::Connection, #run_request] Provide the client which will be used to issue HTTP requests.
    ##
    def set_client(client)
      @client = client
    end

    ##
    # Return the currently active client which will be used to issue HTTP calls.
    #
    # This will be initialized as neded on first access
    # to a default client constructed by the ClientBuilding module.
    #
    # @return [Faraday::Connection, #run_request] Return the active HTTP client.
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
    # @param obj [Object] Provide the data to place in the request body.
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
    # @param method [Symbol] Provide the HTTP method for the request such as returned by #parse_method.
    # @param url [String] Specify the url to which the request will be sent.
    ##
    def send_request(method, url)
      @response = client.run_request(method, url, @body, headers) do |req|
        req.params = request_params
      end
    end

    ##
    # Return the response for the last sent request.
    #
    # @return [Faraday::Response] Return the most recent response.
    ##
    def response
      @response
    end

    ##
    # Expose the headers for the request currently being built.
    #
    # This will be initialized as needed on first access,
    # with a default specifying JSON content-type.
    #
    # @return [Hash] Return the headers to use for the constructed request.
    ##
    def headers
      @headers ||= {content_type: 'application/json'}
    end

    ##
    # Set the specified header to the provided value.
    #
    # @param k [String] Specify the name of the header whose value will be set.
    # @param v [Object] Provide the value to set for the specified header.
    #                   This should normally be a String, but some other types may work.
    ##
    def set_header(k, v)
      headers[k] = v
    end

    ##
    # Expose the query parameters which will be attached to the constructeed request.
    #
    # This will be initialized to an empty hash as needed upon first access.
    #
    # @return [Hash] Return the query parameters to use for the constructed request.
    ##
    def request_params
      @request_params ||= {}
    end

    ##
    # Assign the provided value to the specified request query parameter.
    #
    # @param k [String] Specify the name of the query parameter whose value is being assigned.
    # @param v [Object] Provide the value to assign the query parameter (normally a String).
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

require 'brine/selecting'
require 'brine/transforming'

##
# Define a body for the request currently under construction.
#
# @param input [String] Define the body contents to use in the request.
##
When('the request body is assigned:') do |input|
  body = transformed_parameter(input)
  perform do
    set_request_body(expand(body, binding))
  end
end

##
# Define the indicated query parameter value for the request currently under construction.
#
# @param param [Object] Specify the name of the query parameter whose value will be set.
# @param value [Object] Specify the value to set for the named query parameter.
##
When('the request query parameter {grave_param} is assigned {grave_param}') do |param, value|
  perform { set_request_param(expand(param, value), expand(value, binding)) }
end

##
# Define the indicated header value for the request currently under construction.
#
# @param header [Object] Specify the name of the header whose value will be set.
# @param value [Object] Specify the value to set for the named header.
##
When('the request header {grave_param} is assigned {grave_param}') do |header, value|
  perform { set_header(expand(header, binding), expand(value, binding)) }
end

##
# Issue a request with the provided method to the specified url.
#
# Bind the returned response.
#
# @param method [String] Specify the HTTP method to use for the request.
# @param url [Object] Specify the URL to which the request will be sent.
##
When('a(n) {http_method} is sent to {grave_param}') do |method, url|
  perform do
    send_request(parse_method(method), URI.escape(expand(url, binding)))
    bind('response', response)
    reset_request
  end
end

##
# Attach a HTTP Basic Auth header to the request currently under construction.
#
# @param user [Object] Specify the user with which to generate the header.
# @param password [Object] Specify the password with which to generate the header.
##
When('the request credentials are set for basic auth user {grave_param} and password {grave_param}') do |user, password|
  perform do
    base64_combined = Base64.strict_encode64("#{expand(user, binding)}:#{expand(password, binding)}")
    set_header('Authorization', "Basic #{base64_combined}")
  end
end

##
# Assign a value extracted from a response attribute to the specified identifier.
#
# @param name [Object] Specify the identifier to which the value will be bound.
# @param attribute [String] Specify the attribute from which the value will be retrieved.
# @param traversal [Traversal] Provide a traversal to fetch the value out of the attribute.
##
When('{grave_param} is assigned the response {response_attribute}{traversal}') do
  |name, attribute, traversal|
  perform { bind(expand(name, binding), traversal.visit(response_attribute(attribute))) }
end
