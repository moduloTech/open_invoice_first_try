# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # extension of invoices model for rails_admin
  module InvoicesAdmin

    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_icon 'fa fa-briefcase mr-2'

        # when new record
        create do
          # populate secure_key
          configure :secure_key do
            default_value { SecureRandom.hex(10) }
          end
        end
      end
    end

  end

end
