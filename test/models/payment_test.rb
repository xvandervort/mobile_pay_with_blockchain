require_relative '../test_helper'

class PaymentTest < ActiveSupport::TestCase
  
  test "should hash transaction" do
    trans = Payment.new merchant: 'someone', currency: 'USD', amount: 35.0, user_id: 1
    assert_nil trans.transaction_hash
    trans.save
    assert_not_nil trans.reload.transaction_hash
  end
  
  test "should reject over limit payment" do
    user = users(:three) # low limit
    trans = Payment.create merchant: 'someone', currency: 'USD', amount: 350000.0, user_id: user.id
    trans.apply_rules
    assert !trans.reload.approval_status
  end
  
  test "should convert transaction to hash" do
    user = users(:one)
    merch = 'some merchant'
    curr = 'USD'
    amt = 35.0
    image_hash = 'oinhceiubceiuubiwxihb'
    trans = Payment.create merchant: merch, currency: curr, amount: amt, user_id: user.id, image_hash: image_hash
    target = {
      merchant: merch, currency: curr, amount: amt, user_id: user.id, image_hash: image_hash
    }
    
    assert_equal target, trans.to_h
  end
end
