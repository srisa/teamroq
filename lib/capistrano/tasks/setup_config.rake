# http://www.talkingquickly.co.uk/2014/01/deploying-rails-apps-to-a-vps-with-capistrano-v3/
namespace :deploy do
  task :setup_config do
    on roles(:app) do
      # make the config dir
      execute :mkdir, "-p #{shared_path}/config"
      full_app_name = fetch(:full_app_name)

      # config files to be uploaded to shared/config, see the
      # definition of smart_template for details of operation.
      # Essentially looks for #{filename}.erb in deploy/#{full_app_name}/
      # and if it isn't there, falls back to deploy/#{shared}. Generally
      # everything should be in deploy/shared with params which differ
      # set in the stage files
      config_files = fetch(:config_files)
      config_files.each do |file|
        full_to_path = "#{shared_path}/config/#{file}"
        file_location = "config/deploy/shared/#{file}"
        if file == "application.yml"
          file_location = "config/application.yml"
        end
        from_erb = StringIO.new(File.read(file_location))
        upload! from_erb, "#{shared_path}/config/#{file}"
        info "copying: #{from_erb} to: #{full_to_path}"
      end
    end
  end
end
