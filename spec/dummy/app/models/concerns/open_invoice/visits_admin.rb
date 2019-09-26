# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # extension of visits model for rails_admin
  module VisitsAdmin

    extend ActiveSupport::Concern

    included do
      rails_admin do
        # icon for left menu
        navigation_icon 'fa fa-eye mr-2'

        # this method is used for labels in rails_admin
        object_label_method { :email }
      end
    end

    def email
      recipient&.email
    end

  end

end
