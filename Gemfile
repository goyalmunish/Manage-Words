source 'https://rubygems.org'

ruby '2.2.5'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.15'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
gem 'libv8', '3.16.14.13'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '>= 2.4.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '>= 0.4.0', group: :doc

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
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec-activemodel-mocks'
  gem 'shoulda-matchers', '2.6.1', require: false # TODO: when updated to latest version (2.6.2 at that time, validate_uniqueness_of started failing
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
gem 'flamegraph'

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

