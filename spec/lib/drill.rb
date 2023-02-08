# frozen_string_literal: true

require 'drill/version'
require 'drill/mailer'
require 'drill/delivery_worker'
require 'mandrill'
require 'mailgun-ruby'

module Drill
  Configuration = Struct.new(
    :api_key, :mail_provider, :delivery_method, :default_vars,
    keyword_init: true
  )

  module_function

  def configuration
    @configuration ||= Configuration.new(
      delivery_method: :default,
      default_vars: {}
    )
  end

  def configure
    yield configuration
  end

  def client
    @client ||= provider[configuration.mail_provider].new(configuration.api_key)
  end

  def provider
    { mandrill: Mandrill::API,
      mailgun: Mailgun::Client }
  end
end
