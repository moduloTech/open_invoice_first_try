# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # openinvoice rails engine entry
  class Engine < ::Rails::Engine

    isolate_namespace OpenInvoice

    # add initializer for assets precompile
    initializer 'open_invoice.assets.precompile' do |app|
      app.config.assets.paths << root.join('node_modules')
    end

    # allow to respond to :pdf
    initializer 'open_invoice.mime_types' do
      Mime::Type.register 'application/pdf', :pdf
    end

  end

end
