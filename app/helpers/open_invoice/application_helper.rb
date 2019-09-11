# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # html helper functions
  module ApplicationHelper

    # function to build app title
    def app_title(subtitle=nil)
      # get app name
      app_name = I18n.t('app_name')
      # join subtitle if any with app name
      # when subtitle missing results in app name
      # subtitle "asd" -> "asd : app name"
      # subtitle nil -> "app name"
      [subtitle, app_name].compact.join(' : ')
    end

  end

end
