# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
# recipients controller implements recipients processing for rails_admin
# custom actions
class RecipientsController < ApplicationController

  # devise admin should be authenticated
  before_action :authenticate_admin!

  # endpoint for rails_admin's custom action send_invoice
  # for new - recipients are created
  # for existing recipients we only send an email
  def create
    # read recipients list
    recipients = permitted_recipients[:recipients]
    # if recipients received
    if recipients.present?
      # retrieve existing and create new recipients
      all_recipients = OpenInvoice::Recipients::Prepare.call(recipients)
      # assign invoice and notify recipients
      OpenInvoice::Recipients::Assign.call(
        invoice, all_recipients, list_recipients: permitted_recipients[:list_recipients].present?
      )
      # count all invoice recipients
      total = all_recipients.size
      # add success flash message
      flash[:success] =
        t('recipients.create.success', total:     total,
                                       recipient: t('recipients.create.recipient').pluralize(total))
    else
      # add error message to flash when no emails given
      flash[:alert] = t('recipients.create.fail')
    end

    # redirect back to show invoice page
    redirect_back(
      fallback_location: rails_admin.show_path(model_name: invoice.admin_model_name, id: invoice.id)
    )
  end

  private

  # caches invoice for member actions
  # @return [OpenInvoice::Invoice]
  def invoice
    # find the invoice for recipients creation
    @invoice ||= OpenInvoice::Invoice.find(params.require(:invoice_id))
  end

  # @return [ActionController::Parameters]
  def permitted_recipients
    @permitted_recipients ||= params.permit(:list_recipients, recipients: %i[name email])
  end

end
