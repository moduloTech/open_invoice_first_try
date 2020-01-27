# frozen_string_literal: true

module OpenInvoice

  # admin tokens serve resource owner to allow create/send invoices via api
  class AdminToken < ApplicationRecord

    validates :name, :token, presence: true
    validates :token, uniqueness: true, if: :token_changed?

    after_initialize :regenerate_token, if: :new_record?

    def regenerate_token
      generate_uuid_token(:token)
    end

    def expired?
      expires_at.present? && expires_at < Time.current
    end

    def active?
      !expired?
    end

  end

end
