# frozen_string_literal: true

Rails.application.routes.draw do
  mount OpenInvoice::Engine => '/open_invoice'
  get '/', to: redirect('/open_invoice')

  devise_for :admins, class_name: 'OpenInvoice::Admin', only: :sessions, module: :devise
  mount RailsAdmin::Engine => '/admins', :as => 'rails_admin'
end
