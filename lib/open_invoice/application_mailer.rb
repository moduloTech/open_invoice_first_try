# frozen_string_literal: true

module OpenInvoice

  # base open invoice mailer
  class ApplicationMailer < OpenInvoice.config.mailer_base_class

    # set default from field from config
    default from: OpenInvoice.config.mailer_default_from
    # set email layout from config
    layout OpenInvoice.config.mailer_layout

  end

end
