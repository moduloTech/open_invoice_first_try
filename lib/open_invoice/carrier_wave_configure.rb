# frozen_string_literal: true

require 'fog-aws'

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     OpenInvoice.config.aws_key_id,
    aws_secret_access_key: OpenInvoice.config.aws_secret,
    region:                OpenInvoice.config.aws_region
  }
  config.fog_directory  =  OpenInvoice.config.aws_bucket
  config.fog_public     =  false
  config.fog_attributes =  {}
end
