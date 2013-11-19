require 'capistrano/rbenv'
require 'capistrano/rails'
require 'capistrano/bundler'
# Uncomment if you are using Rails' asset pipeline
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

set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_dir, -> { shared_path.join('bundle') }
set :bundle_flags, '--deployment --quiet'
set :bundle_without, %w{development test}.join(' ')
set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_roles, :all

set :default_env, {   'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" }
#set :bundle_flags, '--deployment --quiet --binstubs'

# set :keep_releases, 5

namespace :deploy do


  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
    end
  end


  after :finishing, 'deploy:cleanup'

end
