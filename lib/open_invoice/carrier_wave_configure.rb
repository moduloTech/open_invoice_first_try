# frozen_string_literal: true

# configure carrierwave to use fog for file storage
CarrierWave.configure do |config|
  # aws credentials
  config.aws_credentials = {
    access_key_id:     OpenInvoice.config.aws_key_id,
    secret_access_key: OpenInvoice.config.aws_secret,
    region:            OpenInvoice.config.aws_region,
    stub_responses:    Rails.env.test? # Optional, avoid hitting S3 actual during tests
  }
  # aws bucket
  config.aws_bucket     = OpenInvoice.config.aws_bucket
  # all files are private by default. when link is obtained it has limited lifetime
  config.aws_acl        = 'private'
  config.aws_attributes = {}
  # link expires in 5 minutes
  config.aws_authenticated_url_expiration = 5.minutes.to_i
end
