# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # recipient information to whom we send an invoice
  class Recipient < ApplicationRecord

    # links to invoices
    has_many :links, class_name: 'OpenInvoice::Link', dependent: :destroy
    # invoices assigned
    has_many :invoices, class_name: 'OpenInvoice::Invoice', through: :links
    # :invoices visits of the recipient
    has_many :visits, class_name: 'OpenInvoice::Visit', dependent: :destroy

    # email & name are required
    validates :name, :email, presence: true
    # when present validate they are unique
    validates :email, uniqueness: true, if: :email
    # when changed validate unique
    validates :public_id, uniqueness: true, if: :public_id_changed?
    validates :api_token, uniqueness: true, if: :api_token_changed?

    # generate tokens for new record
    after_initialize :regenerate_public_id, if: :new_record?
    after_initialize :regenerate_api_token, if: :new_record?

    # name and email for email sending target
    # @return [String]
    def to
      "#{name} <#{email}>"
    end

    # generate unique public_id
    def regenerate_public_id
      generate_uuid_token(:public_id)
    end

    # generate unique api_token
    def regenerate_api_token
      generate_uuid_token(:api_token)
    end

  end

end
