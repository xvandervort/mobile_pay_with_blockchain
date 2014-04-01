class BlocksController < ApplicationController
  def index
    @blocks = Block.all.order(:created_at).reverse_order.limit(10)
  end
  
  def show
    @block = Block.find params[:id]
  end
end
