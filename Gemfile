source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'
gem 'devise'
# Use sqlite3 as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
gem 'haml-rails'
gem 'figaro'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'rest-client'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'puma'

# Use Capistrano for deployment
group :development do
  gem 'capistrano', '~> 3.0.0'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv', github: 'capistrano/rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-puma', github: "seuros/capistrano-puma"
end


group :development, :test do
  gem 'pry_debug'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'awesome_print'
  gem "selenium-webdriver"
  gem "factory_girl"
  gem "bower-rails"
end

group :test do
  gem "shoulda-matchers"
end
