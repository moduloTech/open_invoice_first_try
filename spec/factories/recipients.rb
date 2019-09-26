# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
FactoryBot.define do
  factory :recipient, class: 'OpenInvoice::Recipient' do
    email { 'jdoe@mail.localhost' }
    name { 'John Doe' }
  end
end
