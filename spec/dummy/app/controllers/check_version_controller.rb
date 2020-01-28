# frozen_string_literal: true

require 'check_version'

class CheckVersionController < ApplicationController

  # devise admin should be authenticated
  before_action :authenticate_admin!

  # endpoint
  def index
    # load version checker
    version = CheckVersion.new

    respond_to do |format|
      # only respond to :json format
      format.json do
        render json: {
          outdated: version.outdated?,
          alert:    render_to_string(partial: 'alert.html.erb', locals: { version: version })
        }
      end
    end
  end

end
