# config valid only for current version of Capistrano
lock '3.3.5'


set :application, 'teamroq'
set :deploy_user, 'user_name'
set :rbenv_ruby, '2.0.0'
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:application)}"
set :migrate_target,  :current
set :ssh_options,     { :forward_agent => true }
set :rails_env, "production"
set :rvm1_ruby_version, "2.0.0"


#RVM setup
# setup rvm.
set :rbenv_type, :system
set :rbenv_ruby, '2.0.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git
# set :repo_url, 'git@github.com:srisa/teamroq.git'
set :branch, "master"

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml','config/redis.yml','config/private_pub.yml','config/database.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system','public/images','public/assets')


set(:config_files, %w{database.yml redis.yml private_pub.yml application.yml})
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

  
namespace :bundle do
  task :update do
    on roles(:app) do
      within "#{release_path}" do
        execute :bundle , "install --without development test"
      end
    end
  end
end

# namespace :deploy do
#   namespace :assets do
#     task :precompile do
#       on roles(:web) do
#         from = source.next_revision(current_revision)
#         if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
#           run %Q{cd #{latest_release} && bundle exec #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
#         else
#           logger.info "Skipping asset pre-compilation because there were no asset changes"
#         end
#       end
#     end
#   end
# end

# before "deploy:updated", "bundle:update"
# after "deploy:finished", "foreman:export"
# after "deploy:updated", "foreman:restart"
