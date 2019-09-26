# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # mailer for invoices
  class InvoiceMailer < ApplicationMailer

    # compose mail for recipient to access invoice
    #
    # @param [OpenInvoice::Invoice] invoice assigned invoice
    # @param [OpenInvoice::Recipient] recipient recipient that is addressed by the invoice
    # @param [Array<OpenInvoice::Recipient>, NilClass, false] other_recipients list of all
    # addressees of the invoice to be rendered within email body
    def recipient_added(invoice, recipient, other_recipients=nil)
      # store variables for view
      @invoice = invoice
      @recipient = recipient
      @other = other_recipients
      # take subject from the invoice
      subject = invoice.subject.to_s[0..50]
      # replace subject with app name when missing
      subject = OpenInvoice.app_name if subject.blank?
      # compose mail
      mail(to: recipient.email, subject: subject)
    end

  end

end
