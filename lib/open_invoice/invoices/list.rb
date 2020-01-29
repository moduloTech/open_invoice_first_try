# frozen_string_literal: true

module OpenInvoice

  module Invoices

    # invoices loader
    class List

      # limit page size
      PER_PAGE = 10

      # @param [String, Integer] params_page
      def self.call(params_page=1)
        # convert string or nil into integer. minus one for offset calc
        page = params_page.to_i - 1
        # zero if offset page is negative
        page = 0 if page.negative?
        # retrieve invoices
        Invoice.to_adapter.find_all(order: %i[created_at desc], limit: PER_PAGE,
                                    offset: page * PER_PAGE)
      end

    end

  end

end
