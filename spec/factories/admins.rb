# frozen_string_literal: true

FactoryBot.define do
  factory :admin, class: 'OpenInvoice::Admin' do
    email { 'evil@admin.god' }
    password { 'Test1234' }
    password_confirmation { password }
  end
end
