# frozen_string_literal: true

module OpenInvoice

  # extension of links model for rails_admin
  module LinksAdmin

    extend ActiveSupport::Concern

    included do
      rails_admin do
        # icon for left menu
        navigation_icon 'fa fa-link mr-2'

        # this method is used for labels in rails_admin
        object_label_method { :email }
      end
    end

    def email
      recipient&.email
    end

  end

end
