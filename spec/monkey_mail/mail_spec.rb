# frozen_string_literal: true

require 'monkey_mail'

RSpec.describe MonkeyMail::Mail do
  let(:mail_double) { class_double(MonkeyMail::Mail::Default) }

  describe '::new' do
    it 'delegates ::new to ::mail' do
      params = :params

      allow(MonkeyMail::Mail).to receive(:mail).and_return(mail_double)
      expect(mail_double).to receive(:new).with(params)

      MonkeyMail::Mail.new(params)
    end
  end

  describe '::mail' do
    it 'returns LetterOpener if delivery method is set' do
      allow(MonkeyMail.configuration)
        .to receive(:delivery_method)
        .and_return(:letter_opener)

      expect(MonkeyMail::Mail.mail).to eq(MonkeyMail::Mail::LetterOpener)
    end

    it 'returns Default otherwise' do
      expect(MonkeyMail::Mail.mail).to eq(MonkeyMail::Mail::Default)
    end
  end
end
