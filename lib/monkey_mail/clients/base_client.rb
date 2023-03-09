require 'erb'

module MonkeyMail
  module Clients
    class BaseClient
      def render_template(template_name:, vars: {})
        @template_name = template_name
        @vars = vars
        { 'html' => render_fake_template }
      end

      private

      def render_fake_template
        ERB.new(fake_template).result(binding)
      end

      def fake_template
        %(
          <h1> Template: <%= @template_name %> </h1>
          <h2> Variables </h2>
          <ul>
            <% @vars.each do |var| %>
              <li><b><%= var %></b></li>
            <% end %>
          </ul>)
      end
    end
  end
end
