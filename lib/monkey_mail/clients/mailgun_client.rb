require 'rest_client'
require 'json'

module MonkeyMail
  module Clients
    class MailgunClient
      attr_reader :api_key, :domain

      def initialize(api_key, domain)
        @api_key = api_key
        @domain = domain
      end

      def send_template(template_name:, subject:, from_email:, from_name:, to:, vars:)
        payload = { :from => "#{from_name} <#{from_email}>",
                     :to => to.join(', '),
                     :subject => subject,
                     :template => template_name,
                     't:variables' => vars.to_json }

        RestClient::Request.execute(method: :post,
                                    url: messages_url,
                                    payload: payload)
      end

      def render_template
        raise NotImplementedError
      end

      private

      def messages_url
        "#{api_url}/messages"
      end

      def api_url
        "https://api:#{api_key}@api.mailgun.net/v3/#{domain}"
      end
    end
  end
end

