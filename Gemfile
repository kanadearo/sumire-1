source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.6'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', group: [:development, :test]
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
 gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'factory_bot_rails'
  gem 'rspec'
  gem 'rspec-core'
  gem 'rspec-rails'
  gem 'capistrano'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano3-puma'
  gem 'capistrano-nginx'
end

group :test do
  gem 'capybara', '~> 2.15.4'
  gem 'database_cleaner', '~> 1.0.1'
  gem 'faker', '~> 1.1.2'
  gem 'launchy', '~> 2.3.0'
  gem 'selenium-webdriver', '~>2.45.0'
end

gem 'kaminari'
gem 'rake'
gem 'reek'
gem 'rubocop'
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-line'
gem 'google_places'
gem 'dotenv-rails'
gem 'carrierwave','1.2.2'
gem 'rmagick'
gem 'koala'
gem 'typhoeus'
gem 'fb_graph2'
gem 'will_paginate'
gem 'gmaps4rails'
gem 'acts-as-taggable-on'

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap'
  gem 'rails-assets-bootstrap-tagsinput'
end

gem 'bullet', :group => :development
gem 'remodal-rails'
gem 'font-awesome-rails'
gem 'gon'
gem 'activeadmin'
gem 'fog-aws'
gem 'pg', group: :production
gem 'rails_12factor', group: :production
