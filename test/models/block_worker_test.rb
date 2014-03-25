require_relative '../test_helper'
require 'json'
require 'digest'

class BlockWorkerTest < ActiveSupport::TestCase
  
  test "should assign pool" do
    pool = BlockWorker.get_pool
    assert_not_nil pool
    assert !pool.empty?
  end
  
  test "should create new block with pool" do
    pool = [payments(:three)]
    bw = BlockWorker.init pool
    assert_kind_of BlockWorker, bw
    list = JSON.parse bw.payment_list
    assert_equal pool.first.id, list['payments'].first['id']
    assert_equal pool.size, list['payments'].size
  end
  
  test "should get merkle hash of block" do
    pool = [payments(:three)]
    bw = BlockWorker.init pool
    mh = bw.get_merkle_hash pool
    true_hash = get_true_hash pool

    assert_equal true_hash, mh
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
