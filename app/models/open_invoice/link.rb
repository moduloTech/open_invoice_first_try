# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
module OpenInvoice

  # link model allows recipient to the invoice
  class Link < ApplicationRecord

    # linked invoice
    belongs_to :invoice, class_name: 'OpenInvoice::Invoice'
    # invoice link recipient
    belongs_to :recipient, class_name: 'OpenInvoice::Recipient'

    # check that link is only assigned once
    validates :recipient_id, uniqueness: { scope: :invoice_id }

  end

end
