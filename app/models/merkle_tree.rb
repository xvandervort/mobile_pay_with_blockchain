require 'merkle_leaf'

# merkle tree. Given an array of hashes, will fill the tree
# and return the hash at the top
class MerkleTree
  include ActiveModel::Conversion
  attr_reader :base, :tree_hash # final result all the way up.
  
  # in: an array of hashes to populate the bottom level of the tree
  def initialize(arry = [])
    @base = arry.collect{|el| el }  # poor man's clone
    @tree_hash = run_layers
  end
  
  private
  
  # calculates the next layer on the basis of the current layer
  # IN: an arry of hashes
  def run_one_layer(arry)
    output = []
    
    index_left = 0
    while index_left < arry.size
      leaf = if index_left + 1 < arry.size
        MerkleLeaf.new arry[index_left], arry[index_left + 1]
        
      else
        MerkleLeaf.new arry[index_left]
      end
      
      output << leaf.result_hash
      index_left += 2
    end
    
    output
  end
  
  def run_layers
    #start from base and work your way up
    layer = @base.collect{|v| v}
    do_first_run = true
    while layer.size > 1 || do_first_run
      layer = run_one_layer layer
      do_first_run = false  # it has to run at least once but there could be blocks with only one transaction.
    end
    
    layer.first
  end
end
