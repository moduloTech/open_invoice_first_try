# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
FactoryBot.define do
  factory :invoice, class: 'OpenInvoice::Invoice' do
    amount_vat_excluded { 100 }
    amount_vat_included { 142 }
    secure_key { SecureRandom.hex(10) }
    original_file { File.open(File.expand_path('../files/blank.pdf', Rails.root), 'rb') }
  end
end
