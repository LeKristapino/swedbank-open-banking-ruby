require 'byebug' #TODO: DELETE THIS ROW
require "securerandom"
require "json"
require "rest-client"
require "swedbank/open_banking/version"

module Swedbank
  module OpenBanking
    #OAuth2 token used for authentication
    @@oauth_token = nil
    #Indicates whether API is used in sandbox mode
    @@sandbox_mode = true

    def self.configure
      yield self
    end

    def self.oauth_token=(val)
      @@oauth_token = val
    end

    def self.oauth_token
      @@oauth_token
    end

    def self.sandbox_mode
      @@sandbox_mode
    end

    def self.sandbox_mode=(val)
      unless val.is_a?(TrueClass) || val.is_a?(FalseClass)
        raise ArgumentError, "sandbox_mode setter only accepts boolean values"
      end
      @@sandbox_mode = val
    end
  end
end

require "swedbank/open_banking/request_builder"
require "swedbank/open_banking/transaction"
require "swedbank/open_banking/account"
require "swedbank/open_banking/swedish_domestic_payment"
