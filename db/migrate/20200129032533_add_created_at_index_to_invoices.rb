class AddCreatedAtIndexToInvoices < ActiveRecord::Migration[6.0]

  def change
    add_index :open_invoice_invoices, :created_at
  end

end
