# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
# dummy app root controller
class ApplicationController < ActionController::Base

  # catch errors for dummy
  include OpenInvoice::ErrorHandling

  # allow dummy app views to use helper methods of openinvoice engine
  helper OpenInvoice::Engine.helpers

  layout 'application'

end
