Teamroq::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  # config.logger = Logger.new(Rails.root.join("log",Rails.env + ".log"),2,100*1024)

  # Paperclip.options[:command_path] = "/usr/bin/"
  Paperclip::Attachment.default_options[:url] = '/assets/:class/:attachment/:id_partition/:style/:filename'
  Paperclip::Attachment.default_options[:path] = ':rails_root/public/assets/:class/:attachment/:id_partition/:style/:filename'

  Paperclip.options[:command_path] = ENV["image_magick_install_location"]

  
  config.action_mailer.delivery_method = :smtp

  # Modify the address field if 
  ActionMailer::Base.smtp_settings = {
  :address              => ENV["mailer_smtp_server"],
  :port                 => ENV["mailer_smtp_port"],
  :domain               => ENV["domain_name"],
  :user_name            => ENV["mailer_email_address"],
  :password             => ENV["mailer_email_password"],
  :authentication       => "plain",
  :enable_starttls_auto => true
}
  config.eager_load = false

  config.action_mailer.default_url_options = { :host => 'localhost' }

  ActionMailer::Base.default :from => ENV["mailer_email_address"]


  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.log_level = :debug
  #ckeditor
  # config.autoload_paths += %W(#{config.root}/app/models/ckeditor)

end
