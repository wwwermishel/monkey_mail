# frozen_string_literal: true

require 'monkey_mail'

RSpec.describe MonkeyMail::Clients::BaseClient do
  context '#render_template' do
    let(:params) do
      { template_name: 'some_template_name',
        vars: {
          foo: 'bar',
          baz: 'qux'
        } }
    end

    it 'render template include name' do
      expect(subject.render_template(**params)['html']).to match('some_template_name')
    end

    it 'render template include var' do
      expect(subject.render_template(**params)['html']).to match('bar')
      expect(subject.render_template(**params)['html']).to match('qux')
    end
  end
end
