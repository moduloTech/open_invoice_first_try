OpenInvoice.configure do |config|
  # set directory prefix for uploaded files if given
  config.dir_prefix = ENV['OPEN_INVOICE_DIR_PREFIX'] if ENV['OPEN_INVOICE_DIR_PREFIX']
  # configure storage from ENV
  # else use :aws for production or :file for any other environment
  config.storage =
    ENV.fetch('OPEN_INVOICE_STORAGE') { Rails.env.production? ? :aws : :file }.to_sym

  if ENV['OPEN_INVOICE_AWS_KEY_ID'].present?
    config.aws_key_id = ENV['OPEN_INVOICE_AWS_KEY_ID']
    config.aws_secret = ENV['OPEN_INVOICE_AWS_SECRET']
    config.aws_region = ENV['OPEN_INVOICE_AWS_REGION']
    config.aws_bucket = ENV['OPEN_INVOICE_AWS_BUCKET']
  elsif ENV['CLOUDCUBE_ACCESS_KEY_ID'].present?
    require 'cloud_cube'
    CloudCube.new.integrate(config)
  end

  config.app_name = ENV.fetch('OPEN_INVOICE_APP_NAME') { 'Open Invoice' }
  config.mailer_default_from = ENV['OPEN_INVOICE_MAILER_FROM'] if ENV['OPEN_INVOICE_MAILER_FROM']
  config.domain = ENV.fetch('OPEN_INVOICE_DOMAIN') { 'localhost' }
  config.host = ENV.fetch('OPEN_INVOICE_HOST') { 'http://localhost:3000' }
  Rails.configuration.action_mailer.default_url_options ||= {}
  Rails.configuration.action_mailer.default_url_options[:host] = config.host

  if ENV['SMTP_USERNAME'].blank? && ENV['SENDGRID_USERNAME'].present?
    require 'send_grid'
    Rails.configuration.action_mailer.smtp_settings = SendGrid.settings
  end

  require 'application_record'
  require 'application_mailer'

  config.catch_engine_errors = false

  config.dummy_cache_store = ENV['OPEN_INVOICE_CACHE_STORE'].to_sym if ENV['OPEN_INVOICE_CACHE_STORE']
  config.dummy_session_store = ENV['OPEN_INVOICE_SESSION_STORE'].to_sym if ENV['OPEN_INVOICE_SESSION_STORE']
end
