class Block < ActiveRecord::Base
  belongs_to :block_worker
  delegate :block_hash, :merkle_root, :previous_block_hash, :payment_count, :timestamp, :nonce, :to => :block_worker
  
  has_many :payments
end
