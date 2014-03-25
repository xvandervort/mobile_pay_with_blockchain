class CreateBlockWorkers < ActiveRecord::Migration
  def change
    create_table :block_workers do |t|
      t.string :block_hash
      t.text :data # This is the json transmitted to or received from another node. not yet implemented.
      t.integer :payment_count
      t.text :payment_list # store a serialized array of payment_ids. 

      t.timestamps
    end
  end
end
