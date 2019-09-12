# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # Root controller for OpenInvoice engine
  class ApplicationController < ::ApplicationController

    include ErrorHandler

    # pure layout with vendor styles and js
    layout 'open_invoice/application'

  end

end
