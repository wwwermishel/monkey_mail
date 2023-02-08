require 'rest_client'


module Drill
  module Mailgun
    class Client
      attr_reader :api_key, :domain

      def initialize(api_key, domain)
        @api_key = api_key
        @domain = domain
      end

      def send_template(template:, subject:, from:, to:, vars:)
        RestClient::Request.execute(
                method: :post,
                url: mailgun_url,
                payload: { :from => from,
                           :to => to,
                           :subject => subject,
                           :template => template,
                           't:variables' => vars.to_json })
      end

      def mailgun_url
        api_url+"/messages"
      end

      def api_url
        "https://api:#{api_key}@api.mailgun.net/v3/#{domain}"
      end
    end
  end
end

# api_key = ''
# domain = ''
# client = Drill::Mailgun::Client.new(api_key, domain)

# message_params = {
#   from: "Excited User <mailgun2222@sandboxb6dfe5ba0f6343e5bfac4f84e7eb6d6b.mailgun.org>",
#   to: "dmi.neverov@gmail.com",
#   subject: "Hello",
#   template: "template_name_1",
#   vars: { var_1: 'variable1', var_2: 'variable2' }
# }

# def test(client, message_params)
#   client.send_template(message_params)
# rescue RestClient::Forbidden => e
#   JSON.parse(e.response.body)
# end
# test(client, message_params)
