# I meant to call this the invoice, though it may also accept receipts.
class AddReceiptsToTransactions < ActiveRecord::Migration
  def change
    add_attachment :payments, :invoice
  end
end
