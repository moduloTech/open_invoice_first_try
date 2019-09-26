class CreateOpenInvoiceVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :open_invoice_visits do |t|
      t.references :invoice, type: :uuid, null: false, index: true
      t.references :recipient, type: :uuid, null: false, index: true

      t.timestamp :created_at, null: false
    end
  end
end
