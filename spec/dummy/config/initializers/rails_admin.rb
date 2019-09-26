require 'rails_admin/config/actions/send_invoice'

RailsAdmin.config do |config|

  ### Popular gems integration

  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    # export
    bulk_delete
    show
    send_invoice
    edit
    delete
    # show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end

# load models and inject rails_admin logic
%w[admin invoice recipient visit link].each do |model|
  model_str = "open_invoice/#{model}"
  require model_str
  require "concerns/open_invoice/#{model.pluralize}_admin"
  model_str.classify.constantize.send(
    :include, "open_invoice/#{model.pluralize}_admin".classify.constantize
  )
end
