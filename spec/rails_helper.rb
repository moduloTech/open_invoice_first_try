# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
# code coverage for specs
if ENV.fetch('CODE_COVERAGE', false)
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter 'app/mailer'
  end
end

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('dummy/config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

require 'factory_bot'
FactoryBot.definition_file_paths = ['spec/factories']
FactoryBot.find_definitions

require 'database_cleaner'
DatabaseCleaner.strategy = :transaction

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.before(:all) do
    DatabaseCleaner.clean_with :truncation
    CarrierWave.configure do |cw|
      cw.storage = :file
      cw.enable_processing = false
    end
    OpenInvoice::BaseUploader.prepend(Module.new do
      extend ActiveSupport::Concern

      included do
        storage :file
        cache_storage :file
      end

      def store_dir
        Rails.root.join('tmp/uploads')
      end

      alias_method :cache_dir, :store_dir
    end)
  end

  config.after(:all) do
    FileUtils.rm_rf(Rails.root.join('tmp/uploads'))
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  # config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  # config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # allow to use devise helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
end
