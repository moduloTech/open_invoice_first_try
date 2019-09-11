# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # extension of admin model for rails_admin
  module AdminsAdmin

    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_icon 'fa fa-user-md mr-2'
      end
    end

  end

end
