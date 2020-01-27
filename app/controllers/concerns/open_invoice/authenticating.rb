# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # helper functions for invoices endpoints that require invoice's authentication
  module Authenticating

    extend ActiveSupport::Concern

    included do
      # helper methods to use inside views
      helper_method :current_recipient, :recipient_id_for
    end

    protected

    # open invoice session helper. initializes hash when not present
    # @return [HashWithIndifferentAccess]
    def open_invoice_session
      session[:open_invoice] ||= {}.with_indifferent_access
    end

    # method loads already authenticated recipient from session
    # @return [OpenInvoice::Recipient, NilClass]
    def current_recipient
      # initialize recipient if nil
      @current_recipient ||= headers_recipient || session_recipient || :none
      # if stored value is :none - return nil
      # else return instance of Recipient
      @current_recipient == :none ? nil : @current_recipient
    end

    # loads recipient by api token from headers.
    # @return [OpenInvoice::Recipient, NilClass]
    def headers_recipient
      # get token from headers
      api_token = request.headers[:Authentication]
      # if header is present try to retrieve the recipient from db
      Recipient.to_adapter.find_first(api_token: api_token) if api_token
    end

    def session_recipient
      # take recipient_id from session
      recipient_id = open_invoice_session[:recipient_id]
      # if recipient id is present try to retrieve the recipient from db
      Recipient.to_adapter.get(recipient_id) if recipient_id
    end

    # method to assign current_recipient and store recipient's id to session
    # @param [OpenInvoice::Recipient] recipient
    def current_recipient=(recipient)
      # store recipient's id to session
      open_invoice_session[:recipient_id] = recipient.id
      # store recipient
      @current_recipient = recipient
    end

    # method to be used as before_action
    # if current_recipient is not defined we stop the action processing flow
    # by rendering error
    def require_current_recipient!
      # when current_recipient is defined - exit
      return if current_recipient

      # add not authorized message
      message = I18n.t('not_authorized')
      respond_to do |format|
        # for json render unauthorized and error message
        format.json { render status: :unauthorized, json: { message: message } }
        format.all do
          # for any other format add error message to flash
          flash[:danger] = message
          # redirect to root path
          redirect_to root_path
        end
      end
    end

  end

end
