# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # html helper functions
  module ApplicationHelper

    # function to build app title
    # @param [String] subtitle
    # @return [String]
    def app_title(subtitle=nil)
      # get app name
      app_name = OpenInvoice.app_name
      # join subtitle if any with app name
      # when subtitle missing results in app name
      # subtitle "asd" -> "asd : app name"
      # subtitle nil -> "app name"
      [subtitle, app_name].compact.join(' : ')
    end

    # transforms given flash key into bootstrap default color:
    # primary, secondary, success, danger, warning, info, light, dark
    # @param [String] type
    # @return [String]
    def flash_bootstrap_color(type)
      case type
      when 'notice', 'info'
        'info'
      when 'error', 'fail', 'failure', 'danger'
        'danger'
      when 'alert', 'warning'
        'warning'
      else
        'info'
      end
    end

    # get current controller and action in the format "controller#action"
    # @return [String]
    def current_route
      # take controller and action from params to build the result
      "#{params[:controller]}##{params[:action]}"
    end

    # check if given route is current
    # @param [String] route
    # @return [Boolean]
    def current_route?(route)
      # compare given route string with current_route
      current_route == route
    end

    # helper to receive html class when route is current or nil
    # @param [String] route
    # @param [String] html_class
    # @return [String, NilClass]
    def active_class(route, html_class='active')
      html_class if current_route?(route)
    end

  end

end
