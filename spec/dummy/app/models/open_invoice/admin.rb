# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  class Admin < ::ApplicationRecord

    # allow admin to authenticate
    # validate model on create/update
    # track logins time/ip
    # expire session (30 minutes default)
    # lock account on invalid auth (5 attempts, 10 minutes lock)
    devise :database_authenticatable, :validatable, :trackable, :timeoutable, :lockable

  end

end
