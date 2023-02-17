# frozen_string_literal: true

require 'monkey_mail/version'
require 'monkey_mail/mailer'
require 'monkey_mail/clients/mailgun_client'
require 'monkey_mail/clients/mandrill_client'
require 'monkey_mail/delivery_worker'

module MonkeyMail
  Configuration = Struct.new(
    :provider, :api_key, :domain, :delivery_method, :default_mail_parameters,
    keyword_init: true
  )

  module_function

  def configuration
    @configuration ||= Configuration.new(
      delivery_method: :default,
      default_mail_parameters: {}
    )
  end

  def configure
    yield configuration
  end

  def client
    @client ||= __send__("#{configuration.provider}_client")
  end

  def mandrill_client
    MonkeyMail::Clients::MandrillClient.new(configuration.api_key)
  end

  def mailgun_client
    MonkeyMail::Clients::MailgunClient.new(configuration.api_key, configuration.domain)
  end
end
