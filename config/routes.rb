# frozen_string_literal: true

OpenInvoice::Engine.routes.draw do
  resources :home, only: :index
  root 'home#index'
end
