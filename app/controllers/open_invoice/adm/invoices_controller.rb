# frozen_string_literal: true

require_dependency 'open_invoice/adm/adm_controller'

module OpenInvoice

  module Adm

    # admin invoices controller
    class InvoicesController < AdmController

      # invoices list
      def index
        @invoices = Invoices::List.call(params[:page])
      end

      # show details of the invoice
      def show
        # retrieve the invoice
        @invoice = Invoice.to_adapter.get(params.require(:id))
        # respond 404 when invoice was not found
        head(:not_found) unless @invoice
      end

      # endpoint to create invoices
      # !!! expects multipart/form-data, not json !!!
      def create
        # call create invoice logic
        @invoice = Invoices::Create.call(params.require(:invoice))

        # if invoice was saved
        if @invoice.persisted?
          # respond 201 created and include invoice id
          render :show, status: :created
        else
          # render create errors
          respond_with_record(@invoice)
        end
      end

    end

  end

end
