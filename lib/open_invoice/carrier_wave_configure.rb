# frozen_string_literal: true

# load fog adapter for aws s3 storage
require 'fog-aws'

# configure carrierwave to use fog for file storage
CarrierWave.configure do |config|
  # aws credentials
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     OpenInvoice.config.aws_key_id,
    aws_secret_access_key: OpenInvoice.config.aws_secret,
    region:                OpenInvoice.config.aws_region
  }
  # aws bucket
  config.fog_directory  =  OpenInvoice.config.aws_bucket
  # all files are private by default. when link is obtained it has limited lifetime
  config.fog_public     =  false
  config.fog_attributes =  {}
end
