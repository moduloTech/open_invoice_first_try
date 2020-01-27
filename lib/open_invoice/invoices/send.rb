# frozen_string_literal: true

module OpenInvoice

  module Invoices

    # model to handle new recipients creation, linking invoice to them and sending emails
    class Send

      # @param [OpenInvoice::Invoice] invoice
      # @param [Array<Hash>] param_recipients
      # @param [Boolean] list_recipients
      def self.call(invoice, param_recipients, list_recipients=false)
        # build recipients list. creates new recipients by email if missing
        recipients = Recipients::Prepare.call(Array(param_recipients))
        # assign invoice to recipients allowing them to access the invoice
        # sends invoice mail with unique link to each
        # optionally can include recipient list to the email body
        Recipients::Assign.call(invoice, recipients, list_recipients: list_recipients)
      end

    end

  end

end
