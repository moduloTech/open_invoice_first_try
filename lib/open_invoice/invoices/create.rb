# frozen_string_literal: true

module OpenInvoice

  module Invoices

    class Create

      ATTRIBUTES = %i[subject invoice_number due_date secure_key
                      amount_vat_excluded amount_vat_included original_file].freeze

      # @param [ActionController::Parameters] params
      def self.call(params)
        OpenInvoice::Invoice.create(
          params.permit(*ATTRIBUTES)
        )
      end

    end

  end

end
