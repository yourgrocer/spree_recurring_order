# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_recurring_order'
  s.version     = '2.4.6'
  s.summary     = 'Add the option to create a recurring order'
  s.description = ''
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'Francisco Trindade'
  s.email     = 'frank.trindade@gmail.com'
  s.homepage  = 'http://blog.franktrindade.com'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.4'
  s.add_dependency 'spree_frontend', '~> 2.4'
  s.add_dependency 'spree_backend', '~> 2.4'
  s.add_dependency 'spree_api', '~> 2.4'

  s.add_runtime_dependency 'haml'
  s.add_runtime_dependency 'delayed_job_active_record'
  s.add_runtime_dependency 'pg'

  s.add_development_dependency 'rails', '= 4.1.9'
  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails', '~> 2.9'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'mandrill_mailer'
end
