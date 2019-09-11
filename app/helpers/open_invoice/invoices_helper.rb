# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  module InvoicesHelper

    def due_date_color(invoice)
      return '' unless invoice.due_date

      diff = invoice.due_date - Time.zone.now
      if diff <= 1.day
        'text-danger font-weight-bold'
      elsif diff < 3.days
        'text-warning font-weight-bold'
      else
        ''
      end
    end

  end

end
