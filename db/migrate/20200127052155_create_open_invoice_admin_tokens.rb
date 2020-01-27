class CreateOpenInvoiceAdminTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :open_invoice_admin_tokens do |t|
      t.string :name, null: false
      t.uuid :token, null: false, default: -> { "gen_random_uuid()" }
      t.timestamp :expires_at

      t.timestamps null: false
    end
  end
end
