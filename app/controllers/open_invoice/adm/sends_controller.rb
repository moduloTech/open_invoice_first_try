# frozen_string_literal: true

require_dependency 'open_invoice/adm/adm_controller'

module OpenInvoice

  module Adm

    class SendsController < AdmController

      before_action :require_invoice!

      def create
        Invoices::Send.call(invoice, params.require(:recipients), params[:list_recipients])

        head :ok
      end

      private

      def invoice
        @invoice ||= Invoice.to_adapter.get(params.require(:invoice_id))
      end

      def require_invoice!
        head :not_found unless invoice
      end

    end

  end

end
