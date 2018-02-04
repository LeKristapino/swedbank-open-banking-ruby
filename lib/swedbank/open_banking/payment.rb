module Swedbank
  module OpenBanking
    class Payment
      ALLOWED_TYPES = ['bban', 'iban']

      def initialize(amount:, currency:, from:, to:, type:, reason:)
        raise ArgumentError, "type has to be 'bban' or 'iban'" unless ALLOWED_TYPES.include?(type)

        @params = {
          instructed_amount: { currency: currency, content: amount },
          debtor_account: { "#{type}": from },
          creditor_account: { "#{type}": to },
          remittance_information_unstructured: reason
        }
      end
    end
  end
end
