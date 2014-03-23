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
end
