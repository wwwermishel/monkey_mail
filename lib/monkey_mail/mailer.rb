# frozen_string_literal: true

require 'monkey_mail/mail'

module MonkeyMail
  class Mailer
    PERMITTED_PARAM_KYES = %i[subject from_name from_email to vars template_name skip_delivery]

    attr_reader :action_name

    class << self
      private

      def method_missing(method, *args)
        super unless respond_to_missing?(method)

        new(method).public_send(method, *args)
      end

      def respond_to_missing?(method, include_all = false)
        public_instance_methods(false).include?(method) || super
      end
    end

    def initialize(action_name)
      @action_name = action_name
    end

    def mail(params = {})
      params[:template_name] ||= action_name

      result_params = MonkeyMail.configuration.default_mail_parameters
      result_params.merge!(vars: vars_from_instance_variables)
      result_params.merge!(params)
      result_params[:to] = [params[:to]] if params[:to].is_a? String
      result_params = permitted_params(result_params)

      Mail.new(result_params)
    end

    private

    def permitted_params(params)
      params.slice(*PERMITTED_PARAM_KYES)
    end

    def vars_from_instance_variables
      permitted_instance_variables
        .each.with_object({}) do |instance_variable, vars|
          name = instance_variable.to_s.sub('@', '').to_sym
          content = instance_variable_get(instance_variable)

          vars[name] = content
        end
    end

    def permitted_instance_variables
      instance_variables - %i[@action_name]
    end
  end
end
