require 'capistrano/rbenv'
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/puma'
# require 'capistrano/puma/jungle' #if you need the jungle tasks

set :application, 'best_locator'
set :repo_url, 'git@github.com:svs/best_locator.git'

set :branch, "master"
set :deploy_to, '/home/svs/best_locator'
# set :scm, :git

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.0.0-p247'
set :rbenv_map_bins, ['2.0.0-p247']

set :format, :pretty
set :log_level, :info
# set :pty, true

set :linked_files, %w{config/database.yml config/application.yml config/puma.rb}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_dir, -> { shared_path.join('bundle') }
set :bundle_flags, '--deployment --quiet'
set :bundle_without, %w{development test}.join(' ')
set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_roles, :all

set :migration_role, 'db'

set :default_env, {   'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" }


set :puma_conf, "#{shared_path}/config/puma.rb"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_role, :app
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 16]
set :puma_workers, 0

# set :keep_releases, 5

namespace :deploy do


  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do

    end
  end


  after :finishing, 'deploy:cleanup'

end
