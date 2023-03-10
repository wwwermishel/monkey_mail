# frozen_string_literal: true

require 'monkey_mail'

RSpec.describe MonkeyMail::Mail::LetterOpener do
  let(:mail) do
    MonkeyMail::Mail::LetterOpener.new(params)
  end
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
      allow_any_instance_of(MonkeyMail::Mail::LetterOpener).to receive(:delivery_method).and_return(delivery_method_double)
    end

    describe '#deliver' do
      it 'prepares mail from params' do
        mail.deliver


        aggregate_failures do
          expect(mail.mail.to).to eq(['to@email.com'])
          expect(mail.mail.from).to eq(['johndoe@email.com'])
          expect(mail.mail.sender).to eq('John Doe')
          expect(mail.mail.content_type).to eq('text/html')
          expect(mail.mail.body).not_to be_nil
        end
      end

      it 'delivers mail through delivery method' do
        expect(delivery_method_double).to receive(:deliver!)

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
      allow_any_instance_of(MonkeyMail::Mail::LetterOpener).to receive(:delivery_method).and_return(delivery_method_double)
    end

    describe '#deliver' do
      it 'prepares mail from params' do
        mail.deliver

        aggregate_failures do
          expect(mail.mail.to).to eq(['to@email.com'])
          expect(mail.mail.from).to eq(['johndoe@email.com'])
          expect(mail.mail.sender).to eq('John Doe')
          expect(mail.mail.content_type).to eq('text/html')
          expect(mail.mail.body).to eq('some_html')
        end
      end

      it 'delivers mail through delivery method' do
        expect(delivery_method_double).to receive(:deliver!)

        mail.deliver
      end
    end
  end
end
