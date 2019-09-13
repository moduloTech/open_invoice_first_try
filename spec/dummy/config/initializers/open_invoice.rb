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
end
