require 'rest_client'

module MonkeyMail
  module Clients
    class MandrillClient
      attr_reader :api_key

      def initialize(api_key)
        @api_key = api_key
      end

      def send_template(template_name:, subject:, from_email:, from_name:, to:, vars:)
        message = { from_email: from_email,
                    from_name: from_name,
                    to: prepare_to(to),
                    subject: subject,
                    global_merge_vars: prepate_vars(vars) }

        RestClient::Request.execute(method: :post,
                                    url: template_messages_url,
                                    payload: { key: api_key, template_name: template_name, template_content: [],
                                               message: message })
      end

      def render_template(template_name:, vars:)
        RestClient::Request.execute(method: :post,
                                    url: template_render_url,
                                    payload: { key: api_key, template_name: template_name, template_content: [],
                                               merge_vars: prepate_vars(vars) })
      end

      private

      def prepate_vars(vars)
        vars.map do |name, content|
          { name: name.to_s.upcase, content: content }
        end
      end

      def prepare_recipient(to)
        [{ email: to, type: 'to' }]
      end

      def template_messages_url
        "#{api_url}/messages/send-template"
      end

      def template_render_url
        "#{api_url}/templates/render"
      end

      def api_url
        'https://mandrillapp.com/api/1.0'
      end
    end
  end
end
