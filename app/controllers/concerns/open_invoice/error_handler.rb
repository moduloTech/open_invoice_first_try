# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  module ErrorHandler

    extend ActiveSupport::Concern

    included do
      # add catcher for any not expected errors
      rescue_from StandardError, with: :error_handler
    end

    private

    # error handling function
    def error_handler(error)
      # when in development and engine is configured to raise - raise =)
      raise error if OpenInvoice.config.raise_in_development? && Rails.env.development?

      status, message =
        case error
        when ActionController::ParameterMissing
          [:unprocessable_entity, error.message]
        else
          #     for production
          msg = if Rails.env.production?
                  # TODO: rollbar log exception
                  # replace error message with generic error
                  Rack::Utils::HTTP_STATUS_CODES[500]
                else
                  # else return error message
                  error.message
                end
          [:internal_server_error, msg]
        end

      # write response
      respond_with_error status, message
    end

    # function to write response
    def respond_with_error(status, message)
      respond_to do |format|
        # when format :json
        format.json do
          # write json with error
          render status: status, json: { error: message }
        end
        # when format :pdf or :html
        format.any(:pdf, :html) do
          # write error to flash
          flash[:error] = message
          # redirect to root path
          redirect_to root_path
        end
      end
    end

  end

end
