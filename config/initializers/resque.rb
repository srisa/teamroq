Resque.before_fork do
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
  end

  Resque.after_fork do
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
  end

  Resque.inline = ENV['RAILS_ENV'] == "test"