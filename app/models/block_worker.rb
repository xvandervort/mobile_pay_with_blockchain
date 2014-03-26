require 'json'
class BlockWorker < ActiveRecord::Base
  BlockSize = 50 # pretend limit of the number of transactions that can go in one block.
  
  # ignoring create because this is not a standard type model.
  # It, in fact, generates itself.
  # Create may still be useful for test cases and remote contact, however.
  def self.make
    # step one, pull a list of transactions not already in blocks.
    # If there is nothing in pool, return nil, indicating failure
    @pool = BlockWorker.get_pool
    return if @pool.size == 0
    
    # step 2: save the list of pool to the block worker record. That means creating a record
    @block = BlockWorker.init @pool
    
    #step 3: construct and hash the merkle tree.
    self.block_hash = get_merkle_hash
    save
    
    # AND NOW FOR MY NEXT TRICK .....
    # It's time to do the proof of work. That neds to be an extra step!, not built in.
  end
  
  # retrieve a list of payments not already in a block.
  # This is a place to put business rules about the constitution of blocks.
  def self.get_pool
    Payment.where(block_id: nil).limit(BlockSize)
  end
  
  def self.init(pool)
    h = { payments: pool }.to_json
    BlockWorker.create payment_count: pool.size, payment_list: h
  end
  
  def get_merkle_hash(pool = nil)
    pool ||= @pool
    hashes = pool.collect{|payment| payment.transaction_hash}
    tree = MerkleTree.new hashes
    tree.tree_hash 
  end
  
  def proof_of_work
    # is there a pool?
    @pool ||= BlockWorker.get_pool
    
    # is there a tree hash?
    self.tree_hash = get_merkle_hash
    
    # pow!
    pow = Pow.new self.tree_hash
    self.nonce = pow.run_proof
    save
  end
end
