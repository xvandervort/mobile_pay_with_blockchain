class AddBlockFields < ActiveRecord::Migration
  def change
    add_column :block_workers, :merkle_root, :string
    add_column :block_workers, :timestamp, :datetime
  end
end
