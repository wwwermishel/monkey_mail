# frozen_string_literal: true

require 'monkey_mail'

RSpec.describe MonkeyMail::Mail::LetterOpener do
  let(:mail) do
    MonkeyMail::Mail::LetterOpener.new(params, mail_double, delivery_method_double)
  end
  let(:mail_double) { Mail.new }
  let(:delivery_method_double) do
    instance_double(LetterOpener::DeliveryMethod, deliver!: true)
  end
  let(:params) do
    {
      template_name: :template_name,
      from_name: 'John Doe',
      from_email: 'johndoe@email.com',
      subject: 'subject',
      to: 'to@email.com',
      vars: {
        foo_bar: 'foo_bar',
        bar_foo: 'bar_foo'
      }
    }
  end

  context 'MailgunClient' do
    let(:client) { MonkeyMail::Clients::MailgunClient.new('token123', 'domain') }

    before do
      allow(MonkeyMail).to receive(:client).and_return(client)
    end

    describe '#deliver' do
      it 'prepares mail from params' do
        aggregate_failures do
          expect(mail_double).to receive(:to=).with('to@email.com')
          expect(mail_double).to receive(:from=).with('johndoe@email.com')
          expect(mail_double).to receive(:sender=).with('John Doe')
          expect(mail_double).to receive(:content_type=).with('text/html')
          expect(mail_double).to receive(:body=)
        end

        mail.deliver
      end

      it 'delivers mail through delivery method' do
        expect(delivery_method_double).to receive(:deliver!).with(mail_double)

        mail.deliver
      end
    end
  end

  context 'MandrillClient' do
    let(:client_double) do
      instance_double(MonkeyMail::Clients::MandrillClient, render_template: { 'html' => 'some_html' })
    end

    before do
      allow(MonkeyMail).to receive(:client).and_return(client_double)
    end

    describe '#deliver' do
      it 'prepares mail from params' do
        aggregate_failures do
          expect(mail_double).to receive(:to=).with('to@email.com')
          expect(mail_double).to receive(:from=).with('johndoe@email.com')
          expect(mail_double).to receive(:sender=).with('John Doe')
          expect(mail_double).to receive(:content_type=).with('text/html')
          expect(mail_double).to receive(:body=).with('some_html')
        end

        mail.deliver
      end

      it 'delivers mail through delivery method' do
        expect(delivery_method_double).to receive(:deliver!).with(mail_double)

        mail.deliver
      end
    end
  end
end
