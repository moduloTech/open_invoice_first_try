# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # Root controller for OpenInvoice engine
  class ApplicationController < ::ApplicationController

    include(ErrorHandling) if OpenInvoice.config.catch_engine_errors
    include Authenticating

    # pure layout with vendor styles and js
    layout 'open_invoice/application'

  end

end
