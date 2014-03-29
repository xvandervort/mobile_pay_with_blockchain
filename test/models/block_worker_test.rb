require_relative '../test_helper'
require 'json'
require 'digest'

class BlockWorkerTest < ActiveSupport::TestCase
  
  def setup
    @pool = [payments(:three)]
  end
  
  test "should assign pool" do
    pool = BlockWorker.get_pool
    assert_not_nil pool
    assert !pool.empty?
  end
  
  test "should create new block with pool" do
    bw = BlockWorker.init @pool
    assert_kind_of BlockWorker, bw
    list = JSON.parse bw.payment_list
    assert_equal @pool.first.id, list.first
    assert_equal @pool.size, list.size
  end
  
  test "should get merkle hash of block" do
    bw = BlockWorker.init @pool
    mh = bw.get_merkle_hash @pool
    true_hash = get_true_hash @pool

    assert_equal true_hash, mh
  end
  
  test "should generate header" do
    # I may have to do some definition of payment records in the header
    real_head = {
      block_hash: 'some block hash',
      merkle_root: 'some merkle root (another hash)',
      timestamp: DateTime.now,
      nonce: 12345678,
      previous_block_hash: 'the hash of the block that came before the current block',
      transactions: [payments(:three).transaction_hash]
    }
    bw = BlockWorker.create(
      block_hash: real_head[:block_hash],
      merkle_root: real_head[:merkle_root],
      timestamp: real_head[:timestamp],
      nonce: real_head[:nonce],
      previous_block_hash: real_head[:previous_block_hash],
      payment_count: @pool.size,
      payment_list: @pool.collect{|pl| pl.id}.to_json
    )
    
    # adjust format
    real_head[:timestamp] = real_head[:timestamp].to_i
    
    block_header = bw.header
    assert_equal real_head.to_json, block_header
  end
  
  test "init should pull previous block hash" do
    # does that get included in the merkle tree?
    # looks like no.
    bw = BlockWorker.init @pool
    assert_equal blocks(:two).block_hash, bw.previous_block_hash
  end
  
  test "make should generate block hash" do
    bw = BlockWorker.make
    assert_not_nil bw.block_hash
    assert_equal 40, bw.block_hash.size # 64 if you go to sha256
  end
  
  private
  
  def get_true_hash(pool)
    # This is only 1 layer deep so it's an easy one.
    dig = Digest::SHA256.new
    dig << pool.first.transaction_hash
    dig << pool.first.transaction_hash
    dig.to_s
  end
end
