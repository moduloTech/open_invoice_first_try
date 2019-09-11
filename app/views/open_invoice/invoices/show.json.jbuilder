json.extract! @invoice, :id, :invoice_number, :subject, :due_date, :amount_vat_excluded,
              :amount_vat_included, :vat

json.original_file open_invoice.invoice_url(@invoice, format: :pdf)
