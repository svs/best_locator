
# Uncomment if you are using Rails' asset pipeline
set :application, 'best_locator'
set :repo_url, 'git@github.com:svs/best_locator.git'

set :branch, "master"

set :deploy_to, '/home/svs/best_locator'
# set :scm, :git

set :format, :pretty
set :log_level, :info
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :default_env, {   'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" }
set :bundle_flags, '--deployment --quiet --binstubs'

# set :keep_releases, 5

namespace :deploy do

  after :updated, 'deploy:copy_configs'

  desc 'Copy configuration files'
  task :copy_configs do
    on roles(:app) do
      puts shared_path
      execute :cp, "#{shared_path}/database.yml", "#{current_path}/config/database.yml"
      execute :cp, "#{shared_path}/application.yml", "#{current_path}/config/application.yml"
    end
  end

  after :updated, 'deploy:compile_assets'

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
    end
  end


  after :finishing, 'deploy:cleanup'

end
