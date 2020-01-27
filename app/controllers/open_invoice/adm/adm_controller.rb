# frozen_string_literal: true

require_dependency 'open_invoice/application_controller'

module OpenInvoice

  module Adm

    class AdmController < ApplicationController

      skip_before_action :verify_authenticity_token
      before_action :require_admin!

      protected

      def current_admin
        @current_admin ||= begin
          token = request.headers[:Authentication]
          admin_token = (AdminToken.to_adapter.find_first(token: token) if token)
          admin_token&.active? ? admin_token : :no
        end

        @current_admin != :no
      end

      private

      def require_admin!
        return if current_admin

        respond_with_error :unauthorized, I18n.t('not_authorized')
      end

    end

  end

end
