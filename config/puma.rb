threads 1, 6
workers 2

daemonize true
pidfile '/home/svs/best_locator/shared/tmp/pids/puma.pid'
state_path '/home/svs/best_locator/shared/tmp/pids/puma.state'
bind 'unix:///home/svs/best_locator/shared/tmp/sockets/puma.sock'
environment 'production'
# on_worker_boot do
#   require "active_record"
#   cwd = File.dirname(__FILE__)+"/.."
#   ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
#   ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || YAML.load_file("#{cwd}/config/database.yml")[ENV["RAILS_ENV"]])
# end
