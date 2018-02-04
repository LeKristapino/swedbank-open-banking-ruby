module Swedbank
  module OpenBanking
    class SwedishDomesticPayment
      ALLOWED_TYPES = ['bban', 'iban']

      def initialize(amount:, currency:, from:, to:, type:, reason:, ip_address:)
        raise ArgumentError, "type has to be 'bban' or 'iban'" unless ALLOWED_TYPES.include?(type)
        @ip_address = ip_address
        @params = {
          instructed_amount: { currency: currency, content: amount },
          debtor_account: { "#{type}": from },
          creditor_account: { "#{type}": to },
          remittance_information_unstructured: reason
        }
      end

      def perform
        # As per Swedbank documentation, only available for sweden
        response = Swedbank::OpenBanking::RequestBuilder.new(country: :sweden).post(
          'v1/payments/se-domestic-ct',
          params: @params,
          headers: {
            "PSU-IP-Address": @ip_address
          }
        )

        debugger
      end
    end
  end
end
