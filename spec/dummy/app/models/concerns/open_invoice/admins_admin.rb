# frozen_string_literal: true

module OpenInvoice

  module AdminsAdmin

    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_icon 'fa fa-user-md mr-2'
      end
    end

  end

end
