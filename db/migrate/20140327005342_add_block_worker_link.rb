class AddBlockWorkerLink < ActiveRecord::Migration
  def change
    # We're going to restructure things so that the block can pull most of its data from the worker.
    # BUT WAIT!!! There won't be a worker if the block is generated elsewhere. In that case,
    # one should be generated from the data field. 
    add_column :blocks, :block_worker_id, :integer
    
    # remove redundant column(s)
    remove_column :blocks, :block_hash, :string
    
    # transfer the previous column from block to block worker
    add_column :block_workers, :previous_block_hash, :string
    remove_column :blocks, :previous_block_hash, :string
    
    # transfer the data column from block_worker to blocks. This will hold the whole header, I think
    add_column :blocks, :data, :text
    remove_column :block_workers, :data, :text
  end
end
