# frozen_string_literal: true

module OpenInvoice

  module Invoices

    # model to handle invoices creation
    class Create

      # permitted attributes
      ATTRIBUTES = %i[subject invoice_number due_date secure_key
                      amount_vat_excluded amount_vat_included original_file].freeze

      # @param [ActionController::Parameters] params
      # @return [OpenInvoice::Invoice]
      def self.call(params)
        # create invoice
        OpenInvoice::Invoice.create(
          params.permit(*ATTRIBUTES)
        )
      end

    end

  end

end
