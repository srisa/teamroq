require 'spec_helper'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'devise'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/webkit/matchers'
require 'paper_trail/frameworks/rspec'

  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  load "#{Rails.root}/config/routes.rb"
  Dir["#{Rails.root}/app/**/*.rb"].each {|f| load f}
  Dir["#{Rails.root}/lib/**/*.rb"].each {|f| load f}
  Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

  
  Capybara.configure do |config|
    config.ignore_hidden_elements = false
    config.javascript_driver = :webkit
    config.server_port = 7787
    config.app_host = "http://127.0.0.1:7787"
  end


  Capybara.javascript_driver = :webkit

  # In our setup, for some reason the browsers capybara was driving were
  # not openning the right host:port. Below, we force the correct
  # host:port.
  Capybara.server_port = 7787


  # We have more than one controller inheriting from
  # ActionController::Base, and, in our app, ApplicationController redefines
  # the default_url_options method, so we need to redefine the method for
  # the two classes.
  [ApplicationController, ActionController::Base].each do |klass|
    klass.class_eval do
      def default_url_options(options = {})
        { :host => "127.0.0.1", :port => Capybara.server_port }.merge(options)
      end
    end
  end

  # This code will be run each time you run your specs.
  RSpec.configure do |config|

    config.infer_spec_type_from_file_location!
    config.infer_base_class_for_anonymous_controllers = false
    config.use_transactional_fixtures = false

    config.include Devise::TestHelpers, :type => :controller
    config.include Devise::TestHelpers, :type => :helper
    config.include AcceptanceHelpers, :type => :feature
    config.include FeatureHelpers, :type => :feature
    config.include Capybara::Webkit::RspecMatchers, :type => :feature
  

    config.fixture_path = "#{::Rails.root}/spec/factories"
    
    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.strategy = :transaction
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.before(:each, :js => true) do
      ActiveRecord::Base.establish_connection
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
    end

    config.after(:each, js: true) do
      DatabaseCleaner.clean
      ActiveRecord::Base.establish_connection
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.after(:each) { Warden.test_reset! }
  end