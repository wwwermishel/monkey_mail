# frozen_string_literal: true

require 'monkey_mail'

RSpec.describe MonkeyMail do
  it 'has a version number' do
    expect(MonkeyMail::VERSION).not_to be nil
  end

  describe 'module functions' do
    let(:provider) { :mail_provider }
    before do
      MonkeyMail.configure do |config|
        config.api_key = :api_key
        config.provider = provider
      end
    end

    describe '::configuration' do
      it 'returns correct configuration' do
        expect(MonkeyMail.configuration.api_key).to eq(:api_key)
        expect(MonkeyMail.configuration.provider).to eq(provider)
      end

      it 'sets default configuration' do
        aggregate_failures do
          expect(MonkeyMail.configuration.delivery_method).to eq(:default)
          expect(MonkeyMail.configuration.default_mail_parameters).to eq({})
        end
      end
    end

    describe '::client' do
      context 'mailgun' do
        let(:provider) { 'mailgun' }
        it 'returns mailgun api client' do
          expect(MonkeyMail.client.class).to eq MonkeyMail::Clients::MailgunClient
        end
      end
    end
  end
end
