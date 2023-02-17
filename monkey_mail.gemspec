# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'drill/version'

Gem::Specification.new do |spec|
  spec.name          = 'drill-mailer'
  spec.version       = MonkeyMail::VERSION
  spec.authors       = ['']
  spec.email         = ['']

  spec.summary       = 'ActionMailer like gem for mandrill & mailgun'
  spec.description   = 'ActionMailer like gem for mandrill & mailgun'
  spec.homepage      = 'https://github.com/wwwermishel/monkey_mail'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'letter_opener', '~> 1.8'
  spec.add_development_dependency 'mail', '~> 2.7'

  spec.add_development_dependency 'bundler', '~> 2.4'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.45'
end
