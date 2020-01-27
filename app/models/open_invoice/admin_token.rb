# frozen_string_literal: true

module OpenInvoice

  # admin tokens serve resource owner to allow create/send invoices via api
  class AdminToken < ApplicationRecord

    # token name and the token are required
    validates :name, :token, presence: true
    # validate token uniqueness if it was changed
    validates :token, uniqueness: true, if: :token_changed?

    # fill token when new record is initialized
    after_initialize :regenerate_token, if: :new_record?

    # generate new unique token
    def regenerate_token
      generate_uuid_token(:token)
    end

    # check token expiration
    # @return [Boolean]
    def expired?
      # when field is populated and less than now
      expires_at.present? && expires_at < Time.current
    end

    # check token active (not expired)
    # @return [Boolean]
    def active?
      # inverse of #expired?
      !expired?
    end

  end

end
