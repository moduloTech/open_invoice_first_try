# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
# OpenInvoice engine routes
OpenInvoice::Engine.routes.draw do
  scope ':recipient_id' do
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
