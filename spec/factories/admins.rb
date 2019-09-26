# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
FactoryBot.define do
  factory :admin, class: 'OpenInvoice::Admin' do
    email { 'evil@admin.god' }
    password { 'Test1234' }
    password_confirmation { password }
  end
end
