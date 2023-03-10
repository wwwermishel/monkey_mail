# frozen_string_literal: true

require 'mail'
require 'letter_opener'
require 'letter_opener_web' if defined?(Rails)
require 'monkey_mail/mail/base'

module MonkeyMail
  module Mail
    class LetterOpener < Base
      attr_accessor :mail

      def deliver
        return if params[:skip_delivery]

        prepare_mail!
        delivery_method.deliver!(mail)
      end

      def deliver_later(wait: nil)
        deliver
      end

      private

      def delivery_method
        case MonkeyMail.configuration.delivery_method
        when :letter_opener
          ::LetterOpener::DeliveryMethod.new
        when :letter_opener_web
          ::LetterOpenerWeb::DeliveryMethod.new
        end
      end

      def prepare_mail!
        @mail = ::Mail.new
        mail.to = params[:to]
        mail.from = params[:from_email]
        mail.sender = params[:from_name]
        mail.content_type = 'text/html'
        mail.body = render_html
      end

      def render_html
        MonkeyMail.client.render_template(**render_template_params)['html']
      end
    end
  end
end
