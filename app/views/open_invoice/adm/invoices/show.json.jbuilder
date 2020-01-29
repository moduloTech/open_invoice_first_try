json.merge! @invoice.attributes.except('original_file')
json.set! :original_file do
  json.name @invoice.original_file.identifier
  json.url @invoice.original_file.url
end
