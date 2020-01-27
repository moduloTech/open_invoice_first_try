# frozen_string_literal: true

module OpenInvoice

  module Invoices

    class Send

      # @param [OpenInvoice::Invoice] invoice
      # @param [Array<Hash>] param_recipients
      # @param [Boolean] list_recipients
      def self.call(invoice, param_recipients, list_recipients=false)
        recipients = Recipients::Prepare.call(Array(param_recipients))
        Recipients::Assign.call(invoice, recipients, list_recipients: list_recipients)
      end

    end

  end

end
