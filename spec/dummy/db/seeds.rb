# frozen_string_literal: true

# post-deploy db setup

# find admin with email "admin@admin" or init new record
OpenInvoice::Admin.where(email: 'admin@admin').first_or_create! do |new_admin|
  # set default password to "admin@admin"
  new_admin.password = 'admin@admin'
end
