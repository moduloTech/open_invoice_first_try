# frozen_string_literal: true

require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin

  module Config

    module Actions

      # custom action send_invoice for rails_admin
      # serves the page with ability to build list of recipients and bulk
      # send them emails with link
      class SendInvoice < Base

        # register custom action among rails_admin actions
        Actions.register(self)

        # icon for action
        register_instance_option :link_icon do
          'icon-envelope'
        end

        # limit this action to invoice model only
        register_instance_option :only do
          ['OpenInvoice::Invoice']
        end

        # this proc is called before html page render
        register_instance_option :controller do
          proc do
            # we use it to build email recipient list
            @recipients = OpenInvoice::Recipient.all.map do |recipient|
              [recipient.to, recipient.email]
            end
          end
        end

        # this action is member-based and executes on selected invoice
        register_instance_option :member? do
          true
        end

      end

    end

  end

end
