# frozen_string_literal: true

module OpenInvoice

  module Recipients

    # assign invoice to the recipients
    # creates link between invoice and recipient (if not present)
    # optionally sends notification email to the recipient
    class Assign

      # @param [OpenInvoice::Invoice] invoice assigned invoice
      # @param [Array<OpenInvoice::Recipient>] recipients recipients that should receive the invoice
      # @param [Boolean] notify option to send email to recipient
      # @param [Boolean] list_recipients option to list all other recipients in the email
      # body of each recipient
      def self.call(invoice, recipients, notify: true, list_recipients: true)
        recipients.each do |recipient|
          # create link between invoice and recipient (if not exists)
          recipient.links.where(invoice: invoice).first_or_create!
        end

        # return when no notification required
        return unless notify

        # when we set :list_recipients there should be at least two recipients to show the list,
        # since one of the recipients is the receiver of the email.
        # so we fill list only when options is set and there are more
        # than just one recipient
        list = list_recipients.present? && recipients.size > 1 && recipients
        recipients.each do |recipient|
          # send invoice to each recipient
          InvoiceMailer.recipient_added(invoice, recipient, list).deliver_later
        end
      end

    end

  end

end
