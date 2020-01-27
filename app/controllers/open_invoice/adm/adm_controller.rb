# frozen_string_literal: true

require_dependency 'open_invoice/application_controller'

module OpenInvoice

  module Adm

    # base controller for admin api
    class AdmController < ApplicationController

      # don't require csrf token
      skip_before_action :verify_authenticity_token
      # require admin authentication
      before_action :require_admin!

      protected

      # find current admin token
      # @return [OpenInvoice::AdminToken, NilClass]
      def current_admin
        # cache token
        @current_admin ||= begin
          # check auth_token in headers
          token = request.headers[:Authentication]
          # load admin token from db
          admin_token = (AdminToken.to_adapter.find_first(token: token) if token)
          # if token is present and active - store it
          admin_token&.active? ? admin_token : :no
        end

        # return token or nil
        @current_admin if @current_admin != :no
      end

      private

      # checks active admin token
      def require_admin!
        # return if current token found and active
        return if current_admin

        # render error
        respond_with_error :unauthorized, I18n.t('not_authorized')
      end

    end

  end

end
