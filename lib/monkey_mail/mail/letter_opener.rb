# frozen_string_literal: true

require 'mail'
require 'letter_opener'
require 'monkey_mail/mail/base'

module MonkeyMail
  module Mail
    class LetterOpener < Base
      attr_reader :mail, :delivery_method

      def initialize(
        params,
        mail = ::Mail.new,
        delivery_method = ::LetterOpener::DeliveryMethod.new
      )
        super(params)

        @mail = mail
        @delivery_method = delivery_method
      end

      def deliver
        return if params[:skip_delivery]

        prepare_mail!

        delivery_method.deliver!(mail)
      end

      def deliver_later(wait: nil)
        deliver
      end

      private

      def prepare_mail!
        mail.to =params[:to]
        mail.from = params[:from_email]
        mail.sender = params[:from_name]
        mail.content_type = 'text/html'
        mail.body = render_html
      end

      def render_html
        MonkeyMail.client.render_template(delivery_params)
      end
    end
  end
end
