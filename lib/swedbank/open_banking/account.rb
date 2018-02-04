module Swedbank
  module OpenBanking
    class Account
      attr_reader :id, :currency, :product, :account_type, :iban, :bic, :bban,
        :clearing_number, :account_number, :balances

      def self.list(**opts)
        params = {
          "with-balance": opts[:with_balance] || false
        }

        response = Swedbank::OpenBanking::RequestBuilder.new(**opts).
          get("v1/accounts", params: params)

        hash_response = JSON.parse(response.body).to_h

        return [] unless hash_response['account_list']
        hash_response['account_list'].map { |account_hash| new(account_hash)}
      end

      def self.fetch(id, **opts)
        params = {
          "with-balance": opts[:with_balance] || false
        }
        response = Swedbank::OpenBanking::RequestBuilder.new(**opts).
          get("v1/accounts/#{id}", params: params)
        hash_response = new(JSON.parse(response.body).to_h)
      end

      def initialize(params)
        @raw_hash = params
        @id = params['id']
        @currency = params['currency']
        @product = params['product']
        @account_type = params['account_type']
        @iban = params['iban']
        @bic = params['bic']
        @bban = params['bban']
        @clearing_number = params['clearingnumber']
        @account_number = params['account_number']
        @balances = params['balances']
        @transactions = []
      end

      def transactions(**opts)
        return @transactions unless opts.delete(:reload) || @transactions.empty?
        @transactions = Swedbank::OpenBanking::Transaction.list(id, **opts)
      end
    end
  end
end
