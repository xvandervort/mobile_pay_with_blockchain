class Block < ActiveRecord::Base
  belongs_to :block_worker
  delegate :block_hash, :merkle_root, :previous_block_hash, :timestamp, :nonce, :to => :block_worker
end
