source 'https://rubygems.org'

ruby '2.5.1'
gem 'rails', '4.2.8'
gem 'pg', "~> 0.20"
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', '0.12.3', platforms: :ruby
gem 'libv8', '3.16.14.15'

gem 'jquery-rails'
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '>= 2.4.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Test related gems
group :development, :test do
  gem 'rspec-rails', '>=3.5'
  gem 'rspec-activemodel-mocks'
  gem 'shoulda-matchers', '~>3.1'
  gem 'autotest-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'simplecov'
  # gem 'cucumber-rails', :require => false
  gem 'capybara'
  gem 'selenium-webdriver'
  # gem 'launchy'
end

group :production do
  gem 'rails_12factor'  # it enables serving assets (which is not enabled by default in Rails 4)
end

# Authentication related gems
gem 'devise'
gem 'simple_token_authentication'
gem 'rack-cors', :require => 'rack/cors'

# HTTP, REST client
gem 'rest-client'

# Style related gems
gem 'twitter-bootstrap-rails', '~> 2.2.8' # TODO: when updated to version > 3, UI started behaving weird 

# Console and Debugging related gems
gem 'awesome_print'
gem 'byebug', group: [:development, :test]
gem 'pry-rails'
gem 'pry-doc', group: [:development, :test]
gem 'pry-byebug', group: [:development, :test]

# Performance, profiling, and benchmarking
gem 'rbtrace'
gem 'rack-mini-profiler'
# gem 'flamegraph'

# Server related and Application Start related gems
gem 'puma'
gem 'foreman'

# RinRuby for development
group :development, :test do
  gem 'rinruby'
end

gem 'dalli'
gem 'connection_pool'
gem 'ember-cli-rails'
gem 'httparty'
gem 'tzinfo-data'
gem 'friendly_id'
