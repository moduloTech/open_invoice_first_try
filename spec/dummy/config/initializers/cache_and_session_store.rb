# frozen_string_literal: true

# initializer for session_store and cache_store of dummy app

# when redis cache store is used
if OpenInvoice.config.dummy_cache_store == :redis_cache_store
  # load redis and hiredis driver
  require 'hiredis'
  require 'redis'
  # configure redis server url
  redis_url = ENV.fetch('REDIS_URL') { 'redis://localhost:6379/0' }
  # set cache store to redis
  Dummy::Application.config.cache_store = :redis_cache_store, { url: redis_url, driver: :hiredis }
else
  # use configured value
  Dummy::Application.config.cache_store = OpenInvoice.config.dummy_cache_store
end

# when session store set to activerecord
if OpenInvoice.config.dummy_session_store == :active_record_store
  # load activerecord session_store gem
  require 'activerecord-session_store'
end

# initialize session store
Dummy::Application.config.session_store OpenInvoice.config.dummy_session_store,
                                        expire_after: 90.minutes,
                                        key: "_#{OpenInvoice.app_name.gsub(' ', '').underscore}_session"
