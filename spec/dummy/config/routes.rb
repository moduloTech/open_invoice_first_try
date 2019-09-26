# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
# routes for dummy app
Rails.application.routes.draw do
  # mount engine at /open_invoice endpoint
  mount OpenInvoice::Engine => '/ext'
  # root is redirected to it
  get '/', to: redirect('/ext')

  # devise allow admins only login/logout
  devise_for :admins, class_name: 'OpenInvoice::Admin', only: :sessions, module: :devise

  # mount rails admin engine
  mount RailsAdmin::Engine => '/admins', :as => 'rails_admin'

  # send invoices endpoint
  resources :recipients, only: :create
  # resources for welcome controller
  resources :welcome, only: :index
end
