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

    # email is required
    validates :name, :email, presence: true
    # when present validate it's unique
    validates :email, uniqueness: true, if: :email

    def to
      "#{name} <#{email}>"
    end

  end

end
