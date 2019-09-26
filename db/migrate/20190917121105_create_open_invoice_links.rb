class CreateOpenInvoiceLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :open_invoice_links do |t|
      t.references :invoice, type: :uuid, null: false, index: false
      t.references :recipient, type: :uuid, null: false, index: true

      t.timestamp :created_at, null: false

      t.index %i[invoice_id recipient_id], unique: true
    end
  end
end
