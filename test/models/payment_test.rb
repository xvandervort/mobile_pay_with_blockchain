require_relative '../test_helper'

class PaymentTest < ActiveSupport::TestCase
  
  test "should hash transaction" do
    trans = Payment.new merchant: 'someone', currency: 'USD', amount: 35.0, user_id: 1
    assert_nil trans.transaction_hash
    trans.save
    assert_not_nil trans.reload.transaction_hash
  end
end
