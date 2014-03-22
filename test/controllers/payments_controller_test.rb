require_relative '../test_helper'

class PaymentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user = users(:one)
    @payment = payments(:one)
    sign_in :user, @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payment" do
    assert_difference('Payment.count') do
      post :create, payment: { currency: @payment.currency, image_hash: @payment.image_hash, merchant: @payment.merchant, pre_approval: @payment.pre_approval, transaction_hash: @payment.transaction_hash, user_id: @payment.user_id }
    end

    assert_redirected_to payment_path(assigns(:payment))
  end

  test "should show payment" do
    get :show, id: @payment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payment
    assert_response :success
  end

  test "should update payment" do
    patch :update, id: @payment, payment: { currency: @payment.currency, merchant: @payment.merchant, pre_approval: @payment.pre_approval, user_id: @payment.user_id }
    assert_redirected_to payment_path(assigns(:payment))
  end

  test "should destroy payment" do
    assert_difference('Payment.count', -1) do
      delete :destroy, id: @payment
    end

    assert_redirected_to payments_path
  end
  
  test "index should show only user payments" do
    get :index
    assert assigns(:payments)
    assigns(:payments).each do |pay|
      assert_equal @user.id, pay.user_id
    end
  end
  
  test "create should store payment amount" do
    post :create, payment: { currency: @payment.currency, merchant: @payment.merchant, pre_approval: @payment.pre_approval, user_id: @payment.user_id, amount: '5' }
    pay = Payment.last
    assert_equal 5.0, pay.amount
  end
end
