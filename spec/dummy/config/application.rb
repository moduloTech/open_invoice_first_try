# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
# require "active_job/railtie"
require 'active_record/railtie'
# require "active_storage/engine"
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require "action_cable/engine"
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)
require 'open_invoice'

module Dummy

  class Application < Rails::Application

    # Initialize configuration defaults.
    config.load_defaults 6.0

    # configure redis server url
    redis_url = ENV.fetch('REDIS_URL') { 'redis://localhost:6379/0' }
    # set cache store to redis
    config.cache_store = :redis_cache_store, { url: redis_url, driver: :hiredis }

  end

end

require_relative '../lib/version'
