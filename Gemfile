 source 'https://rubygems.org'

# Core framework
gem 'rails', '~> 4.0.10'

# Memcached client
gem 'dalli', '~> 2.7.2'
# Background Queues
gem "resque", "~> 1.25.2"
# Speeding up the web
gem 'turbolinks', "~> 2.5.2"
# HAML
gem 'haml-rails'
# Attachments
gem 'paperclip', "~> 4.2.0"
# Human friendly urls
gem 'friendly_id', "~> 5.0.4"
# Audits key changes to models
gem 'paper_trail', "~> 3.0.6"
# Rich text editor
gem 'ckeditor_rails', "~> 4.4.3"
# Tags for models
gem 'acts-as-taggable-on' , "~> 3.4.1"
# Handling configuration
gem 'figaro', "~> 1.0.0"

# Auth modules
gem 'devise', "~> 3.4.0"
gem 'cityhash', "~> 0.8.1"
gem 'identity_cache', "~> 0.2.2"
# Redis client
gem 'redis' , "~> 3.1.0"
# Gamification
gem 'gioco', "~> 1.1.1"

# Database client
gem 'pg', "~> 0.17.1"
# Postgres search
gem 'pg_search', "~> 0.7.8"
# Clean up startup for application
gem 'foreman', "~> 0.75.0"
# Push notifications
gem 'private_pub', "~> 1.0.3"
gem 'rack-contrib', "~> 1.1.0"
# Simplifies CSS
gem 'compass-rails', "~> 2.0.0"
# States for todos
gem 'state_machine', "~> 1.2.0"
# roles for users
gem 'rolify', "~> 3.4.1"
# Pagination
gem 'will_paginate', "~> 3.0.7"
# Utility for dates
gem 'groupdate', "~> 2.3.0"


#https://github.com/activeadmin/activeadmin/issues/3093
gem 'sass-rails', github: 'rails/sass-rails'
gem 'coffee-rails', "~> 4.1.0"
gem 'modular-scale', "~> 2.0.4"
gem 'sassy-math', "~> 1.5.1"
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platform => :ruby
gem 'jquery-ui-rails', "~> 5.0.2"
gem 'uglifier', "~> 2.5.3"


group :development,:test do
  gem 'faker'
  gem 'guard'
  gem 'bullet'
  gem 'lorem'
  gem 'launchy'
  gem 'guard-rspec', '~> 4.3.1', require: false
  gem 'guard-bundler', "~> 2.0.0"
  gem 'meta_request', "~> 0.3.4"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'capybara-webkit'
end

  group :production do
    gem 'highline', "~> 1.6.21"
  end

group :test do
  gem 'mock_redis'
  gem 'spork-rails', '~> 4.0.0'
  gem 'capybara', "~> 2.4.4"
  gem 'factory_girl_rails'
  gem 'resque_spec'
end


gem 'jquery-rails', "~> 3.1.2"
gem 'underscore-rails', "~> 1.7.0"


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use puma as the app server
 gem 'puma'
 gem 'thin'

# To use debugger
# gem 'debugger'
#gem 'ruby-debug'
#gem "ruby-debug19", :require => 'ruby-debug'
