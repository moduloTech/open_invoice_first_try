# frozen_string_literal: true

FactoryBot.define do
  factory :recipient, class: 'OpenInvoice::Recipient' do
    email { 'jdoe@mail.localhost' }
    name { 'John Doe' }
  end
end
