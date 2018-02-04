module Swedbank
  module OpenBanking
    class RequestError < StandardError; end
    BIC_CODES = {
      sweden: 'SWEDSESS',
      latvia: 'HABALV22',
      lithuania: 'HABALT22',
      estonia: 'HABAEE2x'
    }

    ROOT_BASE = 'https://psd2.api.swedbank.com/'

    class RequestBuilder
      def initialize(**opts)
        @bic = BIC_CODES[opts[:country] || :sweden]
      end

      def get(url, params: {}, headers: {})
        params = params.merge(bic: @bic)
        headers = default_headers.merge(headers)

        # TODO: RestClient params are pulled out of headers hash
        # Fix is promised in v3 of RestClient
        # see https://github.com/rest-client/rest-client/issues/397
        RestClient.get(root_url + url, {params: params }.merge(headers))

      rescue RestClient::MethodNotAllowed, RestClient::BadRequest, RestClient::InternalServerError => e
        raise Swedbank::OpenBanking::RequestError, e.response
      end

      def post(url, params: {}, headers: {})
        headers = default_headers.merge(headers)
        full_url = root_url + url + "?bic=#{@bic}"
        RestClient.post(full_url, params, headers)

      rescue RestClient::MethodNotAllowed, RestClient::BadRequest, RestClient::InternalServerError => e
        raise Swedbank::OpenBanking::RequestError, e.response
      end

      private

      def root_url
        if Swedbank::OpenBanking.sandbox_mode
          ROOT_BASE + 'sandbox/'
        else
          ROOT_BASE
        end
      end

      def default_headers
        {
          "Authorization": "Bearer #{Swedbank::OpenBanking.oauth_token}",
          "Process-ID": SecureRandom.hex(10),
          "Request-ID": SecureRandom.hex(10),
          "Date": Time.now
        }
      end
    end
  end
end
