# frozen_string_literal: true

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path('spec/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'

load 'rails/tasks/statistics.rake'

require 'bundler/gem_tasks'

if Rails.application.class.name == 'Dummy::Application'
  namespace :assets do
    desc 'Precompile assets within dummy app'
    task :precompile do
      Dir.chdir('spec/dummy') do
        `bundle exec rails assets:precompile`
      end
    end

    desc 'Clean assets within dummy app'
    task :clean do
      Dir.chdir('spec/dummy') do
        `bundle exec rails assets:clean`
      end
    end
  end
end
