# frozen_string_literal: true

module OpenInvoice

  # extension of recipients model for rails_admin
  module RecipientsAdmin

    extend ActiveSupport::Concern

    included do
      rails_admin do
        # icon for left menu
        navigation_icon 'fa fa-bullseye mr-2'

        # this method is used for labels in rails_admin
        object_label_method { :email }

        # exclude associated fields
        exclude_fields :links, :visits, :invoices
      end
    end

  end

end
