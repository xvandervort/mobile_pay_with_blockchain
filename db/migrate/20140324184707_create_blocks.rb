class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :block_hash
      t.string :prev_block_hash
      t.integer :miner_id

      t.timestamps
    end
    
    # and make transactions members of a block.
    add_column :payments, :block_id, :integer
  end
end
