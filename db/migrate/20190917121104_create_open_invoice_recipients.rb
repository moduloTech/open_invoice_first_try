class CreateOpenInvoiceRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :open_invoice_recipients, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false

      t.timestamps null: false

      t.index :email, unique: true
    end
  end
end
