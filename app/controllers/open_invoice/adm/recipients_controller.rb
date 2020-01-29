# frozen_string_literal: true

require_dependency 'open_invoice/adm/adm_controller'

module OpenInvoice

  module Adm

    # controller to handle invoice recipients
    class RecipientsController < AdmController

      # requires invoice
      before_action :require_invoice!

      # show list of invoice recipients
      def index
        @recipients = invoice.recipients
      end

      private

      # load invoice
      # @return [OpenInvoice::Invoice, NilClass]
      def invoice
        @invoice ||= Invoice.to_adapter.get(params.require(:invoice_id))
      end

      # filter to render 404 when invoice is not found
      def require_invoice!
        head(:not_found) unless invoice
      end

    end

  end

end
