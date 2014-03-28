require 'json'
class BlockWorker < ActiveRecord::Base
  BlockSize = 50 # pretend limit of the number of transactions that can go in one block.
  has_one :block
  
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
    @block.merkle_root = @block.get_merkle_hash

    # step 4: Calculate the block hadh
    @block.block_hash = @block.get_block_hash
    @block.save
    
    # AND NOW FOR MY NEXT TRICK .....
    # It's time to do the proof of work. That needs to be an extra step!, not built in.
    
    @block
  end
  
  # retrieve a list of payments not already in a block.
  # This is a place to put business rules about the constitution of blocks.
  def self.get_pool
    Payment.where(block_id: nil).limit(BlockSize)
  end
  
  def self.init(pool)
    h = { payments: pool }.to_json
    
    # slightly naive search for last block!
    prev = Block.last.block_hash
    BlockWorker.create payment_count: pool.size, payment_list: h, previous_block_hash: prev, timestamp: DateTime.now
  end
  
  def get_merkle_hash(pool = nil)
    pool ||= @pool.nil? ? BlockWorker.get_pool : @pool
    hashes = pool.collect{|payment| payment.transaction_hash}
    tree = MerkleTree.new hashes
    tree.tree_hash 
  end
  
  # creates or displays a json object showing the fields of the thing.
  def header
    invoices = get_invoices

    @block_header ||= {
      block_hash: self.block_hash,
      merkle_root: self.merkle_root,
      timestamp: self.timestamp.to_i,
      nonce: self.nonce,
      previous_block_hash: self.previous_block_hash,
      transactions: invoices.collect{|i| i.transaction_hash}
    }.to_json
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
  
  def get_block_hash
    dig = Digest::SHA1.new
    dig << previous_block_hash
    dig << timestamp.to_i.to_s
    dig << merkle_root

    dig.to_s
  end
  
  # converts transaction list to an actual array of invoices
  # Yes, this is a silly way of storing the data but I didn't want a many to many relationship.
  def get_invoices
    out = []
    ids = JSON.parse(self.payment_list)
    ids.each do |i|
      out << Payment.find(i.to_i)
    end
    
    out
  end
end
