# frozen_string_literal: true

require 'mandrill'

RSpec.describe Drill do
  it 'has a version number' do
    expect(Drill::VERSION).not_to be nil
  end

  describe 'module functions' do
    let(:mail_provider) { :mail_provider }
    before do
      Drill.configure do |config|
        config.api_key = :api_key
        config.mail_provider = mail_provider
      end
    end

    describe '::configuration' do
      it 'returns correct configuration' do
        expect(Drill.configuration.api_key).to eq(:api_key)
        expect(Drill.configuration.mail_provider).to eq(mail_provider)
      end

      it 'sets default configuration' do
        aggregate_failures do
          expect(Drill.configuration.delivery_method).to eq(:default)
          expect(Drill.configuration.default_vars).to eq({})
        end
      end
    end

    describe '::client' do
      # after(:each) do
      #   load "lib/drill.rb"
      # end

      # TODO разобраться с очистков переменных в модуле
      # context 'mandrill' do
      #   let(:mail_provider) { :mandrill }
      #   it 'returns mandrill api client' do
      #     expect(Drill.client.class).to eq Mandrill::API
      #   end
      # end

      context 'mailgun' do
        let(:mail_provider) { :mailgun }
        it 'returns mailgun api client' do
          expect(Drill.client.class).to eq Mailgun::Client
        end
      end
    end
  end
end

