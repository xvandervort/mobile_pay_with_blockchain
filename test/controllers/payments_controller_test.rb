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
      post :create, payment: { currency: @payment.currency,
                               image_hash: @payment.image_hash,
                               merchant: @payment.merchant,
                               pre_approval: @payment.pre_approval,
                               transaction_hash: @payment.transaction_hash,
                               amount: 1,
                               user_id: @payment.user_id }
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
  
  test "should get fail whale page" do
    shmo = users(:three)
    sign_in :user, shmo
    bad_payment = Payment.create(currency: 'USD', user_id: shmo.id, amount: 750000000)
    bad_payment.apply_rules
    get :reject, id: bad_payment.id
    assert_response :success
  end
  
=begin
  wtf? RuntimeError: @controller is nil: make sure you set it in your test's setup method.
  test "should reject over limit payments" do
    sign_out @user
    this_user = users(:three)
    sign_in :user, this_user
    post :create, payment: { currency: "USD", merchant: "who cares?", pre_approval: true, user_id: this_user.id, amount: '5000000000' }
    
    pay = Payment.last
    assert !pay.approval_status
    assert_redirected_to reject_payment_path pay.id
  end
=end
end
