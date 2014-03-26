require_relative '../test_helper'
require 'digest'

class PowTest < ActiveSupport::TestCase

  test "should initialize" do
    str = "some merkle hash"
    pow = Pow.new str
    assert_kind_of Pow, pow
    assert_not_nil pow.nonce
  end
  
=begin
  test "attempt proof" do
    # create a hash. Any hash. It doesn't really matter.
    dig = Digest::SHA1.new
    dig << 'just some seed phraseology.'
    str = dig.to_s
    pow = Pow.new str
    pow.run_proof
    flunk
  end
=end
end