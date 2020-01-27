# frozen_string_literal: true

require_dependency 'open_invoice/adm/adm_controller'

module OpenInvoice

  module Adm

    # admin invoices controller
    class InvoicesController < AdmController

      # endpoint to create invoices
      # !!! expects multipart/form-data, not json !!!
      def create
        # call create invoice logic
        @invoice = Invoices::Create.call(params.require(:invoice))

        # if invoice was saved
        if @invoice.persisted?
          # respond 201 created and include invoice id
          render status: :created
        else
          # render create errors
          respond_with_record(@invoice)
        end
      end

    end

  end

end
