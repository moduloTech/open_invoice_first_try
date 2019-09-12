# frozen_string_literal: true

require_dependency 'open_invoice/application_controller'

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # invoices controller allows to access invoices by uuid
  class InvoicesController < ApplicationController

    # wrap content with container
    layout 'open_invoice/container'

    # endpoint to read invoices by uuid
    def show
      # invoice id
      uuid = params.require(:id)
      # retrieve invoice with current orm adapter by uuid
      # may be nil
      @invoice = Invoice.to_adapter.get(uuid)

      respond_to do |format|
        # when invoice found
        if @invoice
          # respond with views for :html and :json
          format.any(:html, :json)
          # redirect to file's direct url for :pdf
          # that link is temporary and expires in the configured period
          # see lib/open_invoice/carrier_wave_configure
          format.pdf { redirect_to @invoice.original_file.url }
        else
          # error message
          message = I18n.t('invoices.show.not_found', uuid: uuid)
          # respond with 404 status for :json
          format.json { render status: :not_found, json: { error: message } }
          # for :html and :pdf
          format.any(:html, :pdf) do
            # add error message to flash
            flash[:error] = message
            # redirect to root url
            redirect_to root_path
          end
        end
      end
    end

  end

end
