# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
# initializer for session_store of the app to use redis

# app name for session key
app_name = ENV.fetch('OPEN_INVOICE_APP_NAME') { Rails.application.class.module_parent_name }
# initialize store
Dummy::Application.config.session_store :cache_store,
                                        expire_after: 90.minutes,
                                        key: "_#{app_name.downcase}_session"
