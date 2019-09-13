# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # uploader for invoice's original file
  class OriginalFileUploader < CarrierWave::Uploader::Base

    # Choose what kind of storage to use for this uploader:
    storage Rails.env.production? ? :aws : :file

    cache_storage :file

    # Override the directory where uploaded files will be stored.
    def store_dir
      File.join(OpenInvoice.config.aws_dir_prefix,
                model.class.to_s.underscore,
                mounted_as.to_s,
                model&.id.to_s)
    end

    # Provide a default URL as a default if there hasn't been a file uploaded:
    # def default_url(*args)
    #   # For Rails 3.1+ asset pipeline compatibility:
    #   # ActionController::Base.helpers.asset_path("fallback/" +
    #       [version_name, "default.png"].compact.join('_'))
    #
    #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    # end

    # Add a white list of extensions which are allowed to be uploaded.
    def extension_whitelist
      %w[pdf]
    end

    # add a whitelist of content types which are allowed to be uploaded.
    def content_type_whitelist
      %w[application/pdf]
    end

  end

end
