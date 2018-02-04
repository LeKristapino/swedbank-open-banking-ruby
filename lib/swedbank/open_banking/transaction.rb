module Swedbank
  module OpenBanking
    class Transaction
      attr_reader :credit_debit, :amount, :booking_date, :transaction_date, :value_date,
        :remittance_information, :currency

      def self.list(account_id, **opts)
        params = {
          "with-balance": opts.delete(:with_balance) || false,
          "date_from":    opts.delete(:date_from)    || Date.today,
          "date_to":      opts.delete(:date_to)      || (Date.today + 1)
        }

        response = Swedbank::OpenBanking::RequestBuilder.new(**opts).
          get("v1/accounts/#{account_id}/transactions", params: params)

        hash_response = JSON.parse(response.body).to_h

        return [] unless hash_response['transactions'] && hash_response['transactions']['booked']
        hash_response['transactions']['booked'].map { |transaction_hash| new(transaction_hash)}
      end

      def initialize(params)
        @raw_hash = params
        @credit_debit = params['credit_debit']
        @amount = params['amount']['content']
        @currency = params['amount']['currency']
        @booking_date = Date.parse(params['booking_date']) if params['booking_date']
        @transaction_date = Date.parse(params['transaction_date']) if params['transaction_date']
        @value_date = Date.parse(params['value_date']) if params['value_date']
        @remittance_information = params['remittance_information']
        @balances = params['balances']
      end
    end
  end
end
