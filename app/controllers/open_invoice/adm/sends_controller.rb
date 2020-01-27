# frozen_string_literal: true

require_dependency 'open_invoice/adm/adm_controller'

module OpenInvoice

  module Adm

    # controller to send invoices
    class SendsController < AdmController

      # find invoice before processing action
      before_action :require_invoice!

      # send action
      def create
        # call send logic
        Invoices::Send.call(invoice, params.require(:recipients), params[:list_recipients])

        # respond 200 ok
        head :ok
      end

      private

      # helper to retrieve invoice
      # @return [OpenInvoice::Invoice, NilClass]
      def invoice
        @invoice ||= Invoice.to_adapter.get(params.require(:invoice_id))
      end

      # check target invoice
      def require_invoice!
        # respond with 404 not found if there is no target invoice
        head :not_found unless invoice
      end

    end

  end

end
