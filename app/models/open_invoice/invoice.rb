# frozen_string_literal: true

module OpenInvoice

  class Invoice < OpenInvoice.config.orm_base_class

    mount_uploader :original_file, OriginalFileUploader

    validates :amount_vat_excluded, :amount_vat_included, :secure_key, :original_file,
              presence: true

  end

end
