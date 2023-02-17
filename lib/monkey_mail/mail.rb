module MonkeyMail
  module Mail
    autoload :Default, 'monkey_mail/mail/default'
    autoload :LetterOpener, 'monkey_mail/mail/letter_opener'

    module_function

    def new(params)
      mail.new(params)
    end

    def mail
      case MonkeyMail.configuration.delivery_method
      when :letter_opener
        LetterOpener
      else
        Default
      end
    end
  end
end
