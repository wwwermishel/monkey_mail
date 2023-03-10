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

    def render_template_params
      params.slice(:template_name, :vars)
    end
  end
end
