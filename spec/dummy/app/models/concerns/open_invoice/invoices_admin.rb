# frozen_string_literal: true

module OpenInvoice

  module InvoicesAdmin

    extend ActiveSupport::Concern

    included do
      rails_admin do
        create do
          configure :secure_key do
            default_value { SecureRandom.hex(10) }
          end
        end
      end
    end

  end

end
