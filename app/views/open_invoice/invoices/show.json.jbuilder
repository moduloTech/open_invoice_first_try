json.invoice do
  json.extract! @invoice, :id, :invoice_number, :subject, :due_date, :amount_vat_excluded,
                :amount_vat_included, :vat
  json.assigned_at @link.created_at
  json.pdf open_invoice.invoice_url(@invoice, format: :pdf, public_id: current_recipient.public_id)
end
json.recipient do
  json.api_token current_recipient.api_token
end
