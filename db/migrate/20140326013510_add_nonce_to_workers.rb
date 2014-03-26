class AddNonceToWorkers < ActiveRecord::Migration
  def change
    add_column :block_workers, :nonce, :string
  end
end
