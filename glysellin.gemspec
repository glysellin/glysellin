$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'glysellin/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'glysellin'
  s.version     = Glysellin::VERSION
  s.authors     = ['Valentin Ballestrino']
  s.email       = ['vala@glyph.fr']
  s.homepage    = 'http://www.glyph.fr'
  s.summary     = 'Lightweight e-commerce'
  s.description = 'When your customer doesn\'t want e-commerce but actually you need products, orders and a payment gateway'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 4.0'
  s.add_dependency 'paperclip'
  s.add_dependency 'aws-sdk'
  s.add_dependency 'money'
  s.add_dependency 'offsite_payments'
  s.add_dependency 'simple_form'
  s.add_dependency 'countries'
  s.add_dependency 'country_select'
  s.add_dependency 'state_machine'
  s.add_dependency 'friendly_id', '~> 5.0'
  s.add_dependency 'devise'
  s.add_dependency 'active_model_serializers', '~> 0.8.0'
  s.add_dependency 'acts-as-taggable-on'
  s.add_dependency 'cic_payment'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 3.0.0.beta'
  s.add_development_dependency 'factory_girl_rails', '~> 4.0'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'spork', '~> 1.0rc'
  s.add_development_dependency 'guard-spork'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'terminal-notifier-guard'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
end
