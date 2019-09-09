# frozen_string_literal: true

module OpenInvoice

  module ApplicationHelper

    def app_title(title=nil)
      default = I18n.t('app_name')
      [title, default].compact.join(' : ')
    end

  end

end
