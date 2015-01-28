namespace :teamroq do
	desc "Creates configuration file"
	task :install => :environment do 
		require "#{Rails.root}/db/gioco/create_badge_Level 1_Team Player.rb"
		require "#{Rails.root}/db/gioco/create_badge_Level 1_Proactive.rb"
		require "#{Rails.root}/db/gioco/create_badge_Level 1_Good Question.rb"
		require "#{Rails.root}/db/gioco/create_badge_Level 1_Good Answer.rb"
		cp 'lib/internal/application.yml.example', 'config/application.yml'
		puts "Application configuration file generated at  'config/application.yml'"
		puts "Important: Edit the configuration file before you continue"
	end

	namespace :setup do
	desc "Creates a admin user."
	task :admin => :environment do 
		email  = ENV["EMAIL"]
		name   = ENV["NAME"]
		password = ENV["password"]
		@user = User.new(email: email, name: name, password: password,password_confirmation: password)
		if @user.save
			puts "User successfully created"
			@user.add_role :admin
			puts "Admin status granted to the user"
		else
			puts "Usage: bundle exec rake teamroq:setup:admin ENV[EMAIL]='user@a.com' ENV[NAME] = 'Srikanth' ENV[PASSWORD]='foobar123'"
		end
	end

	desc "Creates a user."
	task :user => :environment do 
		email  = ENV["EMAIL"]
		name   = ENV["NAME"]
		password = ENV["password"]
		@user = User.new(email: email, name: name, password: password,password_confirmation: password)
		if @user.save
			puts "User successfully created"
		else
			puts "Usage: bundle exec rake teamroq:setup:user ENV[EMAIL]='user@a.com' ENV[NAME] = 'Srikanth' ENV[PASSWORD]='foobar123'"
		end
	end
end
end