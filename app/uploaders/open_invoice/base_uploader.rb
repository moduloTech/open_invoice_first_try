# frozen_string_literal: true

module OpenInvoice

  class BaseUploader < CarrierWave::Uploader::Base

    # Choose what kind of storage to use for this uploader:
    storage OpenInvoice.config.storage
    cache_storage :file

    def initialize(*)
      super

      self.aws_credentials = { access_key_id:     OpenInvoice.config.aws_key_id,
                               secret_access_key: OpenInvoice.config.aws_secret,
                               region:            OpenInvoice.config.aws_region,
                               stub_responses:    Rails.env.test? }
      self.aws_bucket = OpenInvoice.config.aws_bucket
      self.aws_acl = 'private'
      self.aws_attributes = {}
      self.aws_authenticated_url_expiration = 5.minutes.to_i
    end

    # Override the directory where uploaded files will be stored.
    def store_dir
      File.join(OpenInvoice.config.dir_prefix,
                model.class.to_s.underscore,
                mounted_as.to_s,
                model&.id.to_s)
    end

  end

end
