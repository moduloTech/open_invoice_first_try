# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # module implements handling of exceptions in the application controller
  module ErrorHandling

    extend ActiveSupport::Concern

    included do
      # add catcher for any not expected errors
      rescue_from StandardError, with: :error_handler
    end

    private

    # error handling function
    # @param [Exception] error
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
                  # write error to rails log
                  Rails.logger.error(error.message)
                  Rails.logger.error(error.backtrace.first(10))
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
    # @param [String, Symbol] status
    # @param [String] message
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
          flash[:danger] = message
          # redirect back
          redirect_back(fallback_location: '/')
        end
      end
    end

  end

end
