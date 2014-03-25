require 'digest'

# Leaves of a merkle tree
class MerkleLeaf
  include ActiveModel::Conversion
  attr_reader :left, :right, :result_hash
  # in: an array of hashes to populate the bottom level of the tree
  def initialize(left, right = nil)
    @left = left
    @right = right || left # fill the node
    @result_hash = make_hash
  end
  
  private
  
  def make_hash
    dig = Digest::SHA256.new
    dig << @left
    dig << @right
    dig.to_s
  end
end