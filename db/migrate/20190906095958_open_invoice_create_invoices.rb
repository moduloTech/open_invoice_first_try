class OpenInvoiceCreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :open_invoice_invoices, id: :uuid do |t|
      t.string :invoice_number
      t.string :subject
      t.datetime :due_date
      t.string :original_file
      t.decimal :amount_vat_excluded, precision: 10, scale: 2, null: false
      t.decimal :amount_vat_included, precision: 10, scale: 2, null: false
      t.string :secure_key, limit: 20, null: false

      t.timestamps null: false
    end
  end
end
