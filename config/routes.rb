# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
# OpenInvoice engine routes
OpenInvoice::Engine.routes.draw do
  # invoices controller
  resources :invoices, only: :show
  # home route
  resources :home, only: :index
  # home serves as engine's root
  root 'home#index'
end
