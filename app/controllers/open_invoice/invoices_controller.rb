# frozen_string_literal: true

require_dependency 'open_invoice/application_controller'

module OpenInvoice

  # invoices controller allows to access invoices by uuid
  class InvoicesController < ApplicationController

    include FileStreaming

    # wrap content with container
    layout 'open_invoice/container'

    before_action :authenticate_invoice, only: :show
    before_action :require_current_recipient!

    # endpoint to read invoices by uuid
    def show
      respond_to do |format|
        # when invoice found
        if @invoice
          # register the visit
          visit!

          format.json
          format.pdf do
            # stream pdf from carrierwave to customer
            stream_file(@invoice.original_file, params[:inline].present?)
          end
          format.html do
            # skip pdf visit on the html page when it is loaded to the iframe
            open_invoice_session[:skip_pdf_visit] = true
          end
        else
          # error message
          message = I18n.t('invoices.show.not_found', uuid: params[:invoice_id])
          # respond with 404 status for :json
          format.json { render status: :not_found, json: { error: message } }
          # for :html and :pdf
          format.any(:html, :pdf) do
            # add error message to flash
            flash[:danger] = message
            # redirect to root url
            redirect_to root_path
          end
        end
      end
    end

    # list of all recipients invoices
    # this method requires current_recipient to be already authenticated
    def index
      # find all links to assigned invoices
      @links = current_recipient.links.includes(:invoice, :recipient)

      # only respond to html and json formats
      respond_to do |format|
        format.any(:html, :json)
      end
    end

    private

    # method to check recipient and it's access to the invoice
    def authenticate_invoice
      # invoice id
      invoice_id = params.require(:invoice_id)
      # recipient public id
      public_id = params.require(:public_id)
      # all links
      links = Link.to_adapter.find_all(invoice_id: invoice_id).includes(:recipient)
      # link
      @link = links.find { |link| link.recipient.public_id == public_id }
      # when link not found - invoice not found
      return unless @link

      # if recipient is already authenticated use it
      recipient = current_recipient if current_recipient&.public_id == public_id
      # load recipient if not current
      recipient ||= @link.recipient
      # when recipient was not found exit
      return unless recipient

      # retrieve invoice
      @invoice = @link.invoice
      # store recipient to session
      self.current_recipient = recipient
    end

    # method to register recipients visit of the invoice
    def visit!
      # when we've opened html page it tries to load the pdf preview
      # we remembered to skip the visit of pdf format once
      skip_visit = open_invoice_session.delete(:skip_pdf_visit)
      # skip the visit if pdf requested and that's preview for html page
      return if params[:format] == 'pdf' && skip_visit

      # create visit record
      Visit.to_adapter.create!(recipient_id: current_recipient.id, invoice_id: @invoice.id)
    end

  end

end
