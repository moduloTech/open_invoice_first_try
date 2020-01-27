# frozen_string_literal: true

require_dependency 'open_invoice/adm/adm_controller'

module OpenInvoice

  module Adm

    class InvoicesController < AdmController

      def create
        @invoice = Invoices::Create.call(params.require(:invoice))

        if @invoice.persisted?
          render status: :created
        else
          respond_with_record(@invoice)
        end
      end

    end

  end

end
