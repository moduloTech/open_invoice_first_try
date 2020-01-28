# frozen_string_literal: true

FactoryBot.define do
  factory :admin_token, class: 'OpenInvoice::AdminToken' do
    name { 'admin' }
    token { SecureRandom.uuid }
    expires_at { 1.week.from_now }
  end
end
