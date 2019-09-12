# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # helpers for invoices html endpoints
  module InvoicesHelper

    # this function compares due date with current date/time
    # and returns bootstrap 4 text color class
    # less than 3 days to due date - orange = text-warning
    # less than 1 day to due date - red = text-danger
    def due_date_color(invoice)
      # no class needed for empty date
      return '' unless invoice.due_date

      # calculate diff with current datetime
      diff = invoice.due_date - Time.zone.now
      # when less than one day
      if diff <= 1.day
        # red
        'text-danger font-weight-bold'
      # when less than three days
      elsif diff < 3.days
        # orange
        'text-warning font-weight-bold'
      else
        # else no particular color
        ''
      end
    end

  end

end
