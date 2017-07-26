# requester.rb - Provide request construction and response storage

require 'oauth2'
require 'jsonpath'
require 'faraday_middleware'

# Parameter object used to configure OAuth2 middleware
# Also used to provide basic DSL for configuration
class OAuth2Params
  attr_accessor :token, :token_type

  def initialize
    @token_type = 'bearer'
  end

  def fetch_from(id, secret, opts)
    @token = OAuth2::Client.new(id, secret, opts)
      .client_credentials.get_token.token
  end
end

# Construct a Faraday client to be used to send built requests
module ClientBuilding

  # authenticate using provided info and save token for use in later requests
  def use_oauth2_token(&block)
    @oauth2 = OAuth2Params.new
    @oauth2.instance_eval(&block)
  end
  
  def with_oauth2_token(&block)
    use_oauth2_token(&block)
    self
  end

  def client_for_host(host, logging: ENV['BRINE_LOG_HTTP'])
    Faraday.new(host) do |conn|
      conn.request :json

      if @oauth2
        conn.request :oauth2, @oauth2.token, :token_type => @oauth2.token_type
      end
      if logging
        conn.response :logger
      end

      conn.response :json, :content_type => /\bjson$/

      conn.adapter Faraday.default_adapter
    end
  end
end

class ClientBuilder
  include ClientBuilding
end

# Module in charge of constructing requests and saving responses
module Requesting
  include ClientBuilding

  # Utility Methods
  #
  # Normalize an HTTP method passed from a specification into a form
  # expected by the HTTP client library (lowercased symbol)
  def parse_method(method)
    method.downcase.to_sym
  end

  def set_client(client)
    @client = client
  end

  # return Faraday client object so that it could be used directly
  # or passed to another object
  def client
    @client ||= client_for_host((ENV['ROOT_URL'] || 'http://localhost:8080'),
                                logging: ENV['BRINE_LOG_HTTP'])
  end

  # clear out any previously built request state and set defaults
  def reset_request
    @headers = @body = nil
  end

  # store the provided body in the request options being built
  # overriding any previously provided object
  def set_request_body(obj)
    @body = obj
  end

  # send a request using method to url using whatever options
  # have been built for the present request
  def send_request(method, url)
    @response = client.run_request(method, url, @body, @headers)
  end

  # getter for the latest response returned
  def response
    @response
  end

  def headers
    @headers ||= {content_type: 'application/json'}
  end

  # return object in response body at path
  # returns full body if path is omitted
  #TODO: Ugly for now...move away from JsonPath
  def response_body_child(path="")
    JsonPath.new("$.#{path}").on(response.body.to_json)
  end
end

class Requester
  include Requesting
end
