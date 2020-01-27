# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
# OpenInvoice engine routes
OpenInvoice::Engine.routes.draw do
  scope ':public_id' do
    # invoices endpoint to login and view invoice
    resources :invoices, only: :show, param: :invoice_id
  end

  # admin (owner) endpoints
  namespace :adm do
    # create invoices
    resources :invoices, only: :create do
      # and send 'em
      resource :send, only: :create
    end
  end

  # list of invoices for authenticated recipient
  resources :invoices, only: :index, as: :auth_invoices

  # home route
  resources :home, only: :index
  # home serves as engine's root
  root 'home#index'
end
