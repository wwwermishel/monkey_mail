module MonkeyMail
  class Base
    attr_reader :params

    def initialize(params)
      @params = params
    end

    private

    def delivery_params
      params.except(:skip_delivery)
    end
  end
end
