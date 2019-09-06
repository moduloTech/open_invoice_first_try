# frozen_string_literal: true

module OpenInvoice

  class Engine < ::Rails::Engine

    isolate_namespace OpenInvoice

    initializer 'open_invoice.assets.precompile' do |app|
      app.config.assets.paths << root.join('node_modules')
    end

  end

end
