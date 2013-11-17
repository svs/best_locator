require 'puma/capistrano'
set :application, 'best_locator'
set :repo_url, 'git@github.com:svs/best_locator.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/home/svs/best_locator'
# set :scm, :git

set :format, :pretty
set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :default_env, {   'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" }
set :bundle_flags, '--deployment --quiet --binstubs'

# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute 'bundle exec cap puma:start'
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute 'bundle exec cap puma:restart'
    end
  end

  after :finishing, 'deploy:cleanup'

end
