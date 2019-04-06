##
# @file requester.rb
# Request construction and response storage
##

require 'oauth2'
require 'faraday_middleware'
require 'brine/util'

##
# The root url to which Brine will send requests.
#
# This will normally be the value of ENV['BRINE_ROOT_URL'],
# and that value should be directly usable after older
# ENV['ROOT_URL'] is end-of-lifed (at which point this can be removed.
#
# @return [String] The root URL to use or nil if none is provided.
##
def brine_root_url
  if ENV['BRINE_ROOT_URL']
    ENV['BRINE_ROOT_URL']
  elsif ENV['ROOT_URL']
    deprecation_message('1.0', 'ROOT_URL is deprecated, replace with BRINE_ROOT_URL') if ENV['ROOT_URL']
    ENV['ROOT_URL']
  end
end

##
# Parameter object used to configure OAuth2 middleware
#
# Also used to provide basic DSL for configuration
##
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

  # This is represented as list of functions so that it can be more easily customized for
  # unexpected use cases.
  # It should likely be broken up a bit more sensibly and more useful insertion commands added...
  # but it's likely enough of a power feature and platform specific to leave pretty raw.
  def connection_handlers
    @connection_handlers ||= [
      proc do |conn|
        conn.request :json
        if @oauth2
          conn.request :oauth2, @oauth2.token, :token_type => @oauth2.token_type
        end
      end,
      proc do |conn|
        if @logging
          conn.response :logger, nil, :bodies => (@logging.casecmp('DEBUG') == 0)
        end
        conn.response :json, :content_type => /\bjson$/
      end,
      proc{|conn| conn.adapter Faraday.default_adapter }
    ]
  end

  def client_for_host(host, logging: ENV['BRINE_LOG_HTTP'])
    @logging = logging
    Faraday.new(host) do |conn|
      connection_handlers.each{|h| h.call(conn) }
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
    @client ||= client_for_host(brine_root_url || 'http://localhost:8080',
                                logging: ENV['BRINE_LOG_HTTP'])
  end

  # clear out any previously built request state and set defaults
  def reset_request
    @params = @headers = @body = nil
  end

  # store the provided body in the request options being built
  # overriding any previously provided object
  def set_request_body(obj)
    @body = obj
  end

  # send a request using method to url using whatever options
  # have been built for the present request
  def send_request(method, url)
    @response = client.run_request(method, url, @body, headers) do |req|
      req.params = params
    end
  end

  # getter for the latest response returned
  def response
    @response
  end

  def headers
    @headers ||= {content_type: 'application/json'}
  end

  def add_header(k, v)
    headers[k] = v
  end

  def params
    @params ||= {}
  end

  def add_request_param(k, v)
    params[k] = v
  end

end

class Requester
  include Requesting
end
