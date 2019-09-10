# frozen_string_literal: true

module OpenInvoice

  class Invoice < OpenInvoice.config.orm_base_class

    mount_uploader :original_file, OriginalFileUploader

    validates :amount_vat_excluded, :amount_vat_included, :secure_key, :original_file,
              presence: true
    validates :amount_vat_included,
              numericality: { greater_than_or_equal_to: :amount_vat_excluded },
              if:           -> { amount_vat_included && amount_vat_excluded }

  end

end
