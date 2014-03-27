class FixFieldsRearrangedIncorrectly < ActiveRecord::Migration
  def change
    remove_column :blocks, :prev_block_hash, :string
  end
end
