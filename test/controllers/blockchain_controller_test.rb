require_relative '../test_helper'

class BlockchainControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user = users(:one)
    @payment = payments(:one)
    sign_in :user, @user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "index should retrieve last 10 blocks" do
    # if there are ten
    get :index
    assert assigns(:blocks), "Why did it not assign the blocks array?"
    assert (assigns(:blocks).size <= 10), "Why is the blocks array so big? #{ assigns(:blocks).size }"
    assert (assigns(:blocks).size > 0), "Why is the array of blocks empty?"
  end
end
