json.array! @links do |link|
  json.extract! link.invoice, :id, :subject
  json.url invoice_url(link.invoice, format: :json, recipient_id: link.recipient_id)
  json.pdf invoice_url(link.invoice, format: :pdf, recipient_id: link.recipient_id)
end
