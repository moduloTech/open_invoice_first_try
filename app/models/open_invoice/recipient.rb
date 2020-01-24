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

    after_initialize :generate_unique_keys, if: :new_record?

    def to
      "#{name} <#{email}>"
    end

    private

    def generate_unique_keys
      loop do
        self.public_id = SecureRandom.uuid
        self.api_token = SecureRandom.uuid

        duplicates = self.class.where(
          arel_table[:public_id].eq(public_id).or(
            arel_table[:api_token].eq(api_token)
          )
        ).any?

        break unless duplicates
      end
    end

  end

end
