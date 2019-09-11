# frozen_string_literal: true

require_dependency 'open_invoice/application_controller'

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  class InvoicesController < ApplicationController

    layout 'open_invoice/container'

    def show
      @invoice = Invoice.to_adapter.get(params.require(:id))
      return redirect_to(root_path) unless @invoice

      respond_to do |format|
        format.pdf { redirect_to @invoice.original_file.url }
        format.json
        format.html
      end
    end

  end

end
