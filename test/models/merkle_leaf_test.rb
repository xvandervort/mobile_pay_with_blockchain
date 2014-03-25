require_relative '../test_helper'

class MerkleLeafTest < ActiveSupport::TestCase
  
  def setup
    @left = 'left hash'
    @right = 'right hash'
    @ml = MerkleLeaf.new @left, @right 
  end
  
  test "should initialize" do
    assert_kind_of MerkleLeaf, @ml
    assert_equal @left, @ml.left
    assert_equal @right, @ml.right
  end
  
  test "should hash left and right using sha256" do
    assert_equal "ea09495292e313ccfe35718b77d2a691d5a92de2a3f1f02685d7cd0e973a4007", @ml.result_hash
  end
end
