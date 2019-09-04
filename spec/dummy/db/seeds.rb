# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
# local dev db setup

# exit when environment is not development
return unless Rails.env.development?

# find admin with email "test@admin.local" or init new record
OpenInvoice::Admin.where(email: 'test@admin.local').first_or_initialize do |new_admin|
  # set password to "1"
  new_admin.password = '1'
  # save without validation to bypass pwd validation rules
  new_admin.save(validate: false)
end
