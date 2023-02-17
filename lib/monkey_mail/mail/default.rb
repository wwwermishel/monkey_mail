# frozen_string_literal: true

require 'monkey_mail/mail/base'

module MonkeyMail
  module Mail
    class Default < Base
      def deliver
        return if params[:skip_delivery]

        MonkeyMail.client.send_template(**delivery_params)
      end

      def deliver_later(wait: nil)
        return if params[:skip_delivery]

        raise NotImplementedError

        # if wait
        #   worker.perform_in(wait.to_i, template_name, message_hash)
        # else
        #   worker.perform_async(template_name, message_hash)
        # end
      end

      private

      def worker
        Drill::DeliveryWorker
      end
    end
  end
end
