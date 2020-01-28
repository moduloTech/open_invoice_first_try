# frozen_string_literal: true

module OpenInvoice

  # extension of admin model for rails_admin
  module AdminsAdmin

    extend ActiveSupport::Concern

    included do
      rails_admin do
        # icon for left menu
        navigation_icon 'fa fa-user-md mr-2'

        # this method is used for labels in rails_admin
        object_label_method { :email }
      end
    end

  end

end
