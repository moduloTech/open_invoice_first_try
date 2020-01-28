# frozen_string_literal: true

module OpenInvoice

  # uploader for invoice's original file
  class OriginalFileUploader < BaseUploader

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
