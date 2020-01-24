json.array! @links do |link|
  json.extract! link.invoice, :id, :subject
  json.url invoice_url(link.invoice, format: :json, public_id: link.recipient.public_id)
  json.pdf invoice_url(link.invoice, format: :pdf, public_id: link.recipient.public_id)
end
