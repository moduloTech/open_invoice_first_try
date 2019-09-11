# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # model to store invoice information
  class Invoice < ApplicationRecord

    # carrierwave uploader mounted to field :original_file
    # it should be a pdf file
    mount_uploader :original_file, OriginalFileUploader

    # amounts, secure key and original_file are required
    validates :amount_vat_excluded, :amount_vat_included, :secure_key, :original_file,
              presence: true
    # amount vat included should be >= than amount vat excluded
    # validation takes place only when both fields are present
    validates :amount_vat_included,
              numericality: { greater_than_or_equal_to: :amount_vat_excluded },
              if:           -> { amount_vat_included && amount_vat_excluded }

    def vat
      amount_vat_included - amount_vat_excluded
    end

  end

end
