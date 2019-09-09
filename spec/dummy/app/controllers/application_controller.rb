# frozen_string_literal: true

class ApplicationController < ActionController::Base

  helper OpenInvoice::Engine.helpers

  layout 'application'

end
