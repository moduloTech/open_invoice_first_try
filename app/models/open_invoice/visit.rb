# frozen_string_literal: true

module OpenInvoice

  # model to store recipient invoice visits
  class Visit < ApplicationRecord

    # visited invoice
    belongs_to :invoice, class_name: 'OpenInvoice::Invoice'
    # invoice visitor
    belongs_to :recipient, class_name: 'OpenInvoice::Recipient'

  end

end
