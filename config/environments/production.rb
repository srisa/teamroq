
Teamroq::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  config.eager_load = true
  
  # Code is not reloaded between requests
  config.cache_classes = true

  # Paperclip::Attachment.default_options[:url] = 'http://docs.teamroq.com'
  #Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
    Paperclip::Attachment.default_options[:url] = '/assets/:class/:attachment/:id_partition/:style/:filename'
  Paperclip::Attachment.default_options[:path] = ':rails_root/public/assets/:class/:attachment/:id_partition/:style/:filename'

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => ENV["domain_name"] }

  # Modify the address field if 
  ActionMailer::Base.smtp_settings = {
  :address              => ENV["mailer_smtp_server"],
  :port                 => ENV["mailer_smtp_port"],
  :domain               => ENV["domain_name"],
  :user_name            => ENV["mailer_email_address"]
  :password             => ENV["mailer_email_password"],
  :authentication       => "plain",
  :enable_starttls_auto => true
}
  ActionMailer::Base.default :from => 'ENV["mailer_email_address"]'

  ActionMailer::Base.default :to => 'ENV["mailer_email_address"]'

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  config.assets.js_compressor = :uglifier

  # Add the fonts path
  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

  # Precompile additional assets
  config.assets.precompile += %w(chartkick.js .svg .eot .woff .ttf )

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true


  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
   config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  config.cache_store = :dalli_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w()

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end
