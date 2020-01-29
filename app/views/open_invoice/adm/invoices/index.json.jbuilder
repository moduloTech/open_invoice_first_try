json.array! @invoices do |invoice|
  json.extract! invoice, :id, :subject, :created_at
  json.amount invoice.amount_vat_included
end
