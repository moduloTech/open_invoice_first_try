class AddTokenFiledsToRecipients < ActiveRecord::Migration[6.0]
  def change
    change_table :open_invoice_recipients, bulk: true do |t|
      t.uuid :public_id, null: false, default: -> { "gen_random_uuid()" }
      t.uuid :api_token, null: false, default: -> { "gen_random_uuid()" }
      t.index :public_id, unique: true
      t.index :api_token, unique: true
    end
  end
end
