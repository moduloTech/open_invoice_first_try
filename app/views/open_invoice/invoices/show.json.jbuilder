json.extract! @invoice, :id, :invoice_number, :subject, :due_date, :amount_vat_excluded,
              :amount_vat_included, :vat
json.assigned_at @link.created_at
json.pdf open_invoice.invoice_url(@invoice, format: :pdf, recipient_id: current_recipient.id)
