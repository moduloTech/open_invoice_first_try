# frozen_string_literal: true

require_dependency 'open_invoice/application_controller'

module OpenInvoice

  # Engine root controller. May serve as a dashboard in future.
  # here we arrive when access engine mount point
  # this controller is not going to process any specific logic
  class HomeController < ApplicationController

    layout 'open_invoice/container'

    # one and only :index action here
    # serves html page with project description
    def index
    end

  end

end
