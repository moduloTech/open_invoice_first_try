# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gemspec

gem 'devise', '~> 4.7'
gem 'puma', '~> 4.1'
gem 'pg', '~> 1.1'
gem 'rails_admin', '~> 2.0'
gem 'rest-client', '~> 2.1'

# storages for cache and session
gem 'hiredis', '~> 0.6', require: false
gem 'redis', '~> 4.1', require: false
gem 'activerecord-session_store', '~> 1.1', require: false

group :development, :test do
  gem 'rubocop', '~> 0.74', require: false
  gem 'rubocop-rails', '~> 2.3', require: false
end

group :test do
  gem 'rspec-rails', '~> 4.0.0.beta2'
  # gem 'rails-controller-testing'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'simplecov', require: false
end
