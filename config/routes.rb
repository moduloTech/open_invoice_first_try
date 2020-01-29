# frozen_string_literal: true

# OpenInvoice engine routes
OpenInvoice::Engine.routes.draw do
  # admin (owner) endpoints
  namespace :adm do
    # create invoices
    resources :invoices, only: %i[create show index] do
      # and send 'em
      resource :send, only: :create
      # list recipients per invoice
      resources :recipients, only: :index
    end
  end

  scope ':public_id' do
    # invoices endpoint to login and view invoice
    resources :invoices, only: :show, param: :invoice_id
  end

  # list of invoices for authenticated recipient
  resources :invoices, only: :index, as: :auth_invoices

  # home route
  resources :home, only: :index
  # home serves as engine's root
  root 'home#index'
end
