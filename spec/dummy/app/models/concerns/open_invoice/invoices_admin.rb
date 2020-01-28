# frozen_string_literal: true

module OpenInvoice

  # extension of invoices model for rails_admin
  module InvoicesAdmin

    extend ActiveSupport::Concern

    included do
      rails_admin do
        # icon for left menu
        navigation_icon 'fa fa-briefcase mr-2'

        # when new record
        create do
          # populate secure_key
          configure :secure_key do
            default_value { SecureRandom.hex(10) }
          end

          # exclude associated fields
          exclude_fields :links, :visits, :recipients
        end

        # this method is used for labels in rails_admin
        object_label_method { :id }

        # exclude associated fields
        exclude_fields :links, :visits, :recipients
      end
    end

  end

end
