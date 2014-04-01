class BlockchainController < ApplicationController
  def index
    @blocks = Block.all.order(:created_at).reverse_order.limit(10)
  end
end
