# frozen_string_literal: true

require 'fog-aws'

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     ENV['AWS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET'],
    region:                ENV['AWS_REGION']
  }
  config.fog_directory  =  ENV['AWS_BUCKET']
  config.fog_public     =  false
  config.fog_attributes =  {}
end
