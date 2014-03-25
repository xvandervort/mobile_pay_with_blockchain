require_relative '../test_helper'
require 'digest'

class MerkleTreeTest < ActiveSupport::TestCase
  def setup
    @arry = ['one', 'two', 'three', 'four']
    @mrk = MerkleTree.new @arry
  end
  
  test "should initialize from array" do
    assert_kind_of MerkleTree, @mrk
    assert_equal 4, @mrk.base.size
  end
  
  test "should hash the tree all the way up" do
    # so now I have to compute all the way up here
    dig = Digest::SHA256.new
    dig << @arry[0]
    dig << @arry[1]
    layer2_left = dig.to_s
    dig.reset
    
    dig << @arry[2]
    dig << @arry[3]
    layer2_right = dig.to_s
    dig.reset
    
    dig << layer2_left
    dig << layer2_right
    final = dig.to_s
    dig.reset
    
    assert_equal final, @mrk.tree_hash
  end
end