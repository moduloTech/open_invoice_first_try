# frozen_string_literal: true

module OpenInvoice

  module Recipients

    # prepare recipient list from array of hashes
    # should have :email and :name (for new recipients) populated
    # elements with missing email are skipped
    # e.g.
    # recipients = [{name: 'john', email: 'jdoe@example.com'}, {email: 'existing@recipient.com'}]
    class Prepare

      # @param [Array<Hash, #values_at>] recipients
      # @return [Array<OpenInvoice::Recipient>]
      def self.call(recipients)
        recipients.map { |recipient|
          # take email and name
          email, name = recipient.values_at(:email, :name)
          # email should be present, else skip
          next if email.blank?

          # remove extra spaces and downcase the email
          email = email.strip.downcase

          # find existing recipient by email
          existing = Recipient.to_adapter.find_first(email: email)
          # return existing recipient
          next existing if existing

          # create new recipient
          Recipient.to_adapter.create!(email: email, name: name)
        }.compact
      end

    end

  end

end
