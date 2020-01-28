# frozen_string_literal: true

module OpenInvoice

  # model to store invoice information
  class Invoice < ApplicationRecord

    # carrierwave uploader mounted to field :original_file
    # it should be a pdf file
    mount_uploader :original_file, OriginalFileUploader

    # links that allow recipient access to invoice
    has_many :links, class_name: 'OpenInvoice::Link', dependent: :destroy
    # recipients that receive invoice
    has_many :recipients, class_name: 'OpenInvoice::Recipient', through: :links
    # recipient visits of invoice links
    has_many :visits, class_name: 'OpenInvoice::Visit', dependent: :destroy

    # amounts, secure key and original_file are required
    validates :amount_vat_excluded, :amount_vat_included, :secure_key, :original_file,
              presence: true
    # amount vat included should be >= than amount vat excluded
    # validation takes place only when both fields are present
    validates :amount_vat_included,
              numericality: { greater_than_or_equal_to: :amount_vat_excluded },
              if:           -> { amount_vat_included && amount_vat_excluded }

    # VAT helper function
    # calculates as diff between amounts with and without VAT
    def vat
      amount_vat_included - amount_vat_excluded
    end

  end

end
