require 'rest_client'

module MonkeyMail
  module Clients
    class MandrillClient
      attr_reader :api_key

      def initialize(api_key, _domain)
        @api_key = api_key
      end

      def send_template(template_name:, subject:, from_email:, from_name:, to:, vars:)
        message = { from_email: from_email,
                    from_name: from_name,
                    to: to,
                    subject: subject,
                    global_merge_vars: vars }

        RestClient::Request.execute(method: :post,
                                    url: template_messages_url,
                                    payload: { key: api_key, template_name: template_name, message: message })
      end

      def render_template
        raise NotImplementedError
      end

      private

      def template_messages_url
        "#{api_url}'/messages/send-template"
      end

      def api_url
        'https://mandrillapp.com/api/1.0'
      end
    end
  end
end
