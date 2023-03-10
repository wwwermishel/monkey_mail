# frozen_string_literal: true

require 'monkey_mail'

RSpec.describe MonkeyMail::Mail::Default do
  let(:mail) { MonkeyMail::Mail::Default.new(mail_params) }
  let(:mail_params) do
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

  before do
    allow(MonkeyMail).to receive(:client).and_return(client_double)
  end

  describe '#deliver' do
    context 'MailgunClient' do
      let(:client_double) { instance_double(MonkeyMail::Clients::MailgunClient) }

      it 'sends template' do
        expect(client_double).to receive(:send_template)

        mail.deliver
      end

      context "when 'skip_delivery' is true" do
        let(:mail_params) { super().merge(skip_delivery: true) }

        it "doesn't send template" do
          expect(client_double).not_to receive(:send_template)

          mail.deliver
        end
      end
    end

    context 'MandrillClient' do
      let(:client_double) { instance_double(MonkeyMail::Clients::MandrillClient) }

      # TODO
      # it 'sends template with correct message' do
      # end
    end
  end
end
