namespace :foreman do
  desc "Export the Procfile to upstart scripts"
  task :export do
    on roles(:app) do
      within "#{current_path}" do
        execute  "foreman export upstart /etc/init -a teamroq -u root -l /var/log/teamroq"
      end
    end
  end
  
  desc "Start the application services"
  task :start do
    on roles(:app) do
      execute "service start teamroq"
    end
  end

  desc "Stop the application services"
  task :stop do
    on roles(:app) do
      execute "service stop teamroq"
    end
  end

  desc "Restart the application services"
  task :restart do
    on roles(:app) do
      execute "service restart teamroq"
    end
  end
end