require 'digest'
# computes proof of work using Bitcoin system (sha256 of sha1)
# Todo: Make this threaded and killable if it takes too long
class Pow  # proof of work
  include Nonce
  attr_reader :nonce, :message, :result_hash, :candidate
  
  def initialize(message, level = 10)
    @message = message
    @nonce = generate(8)
    @level = level
    @result_hash = ''
  end
  
  def make_target
    dig = Digest::SHA1.new
    dig << @nonce
    dig << @message
    
    @candidate = dig.to_s
    # NOTE that the correct thing to do here for bitcoinness would be to  take the SHA256 hash of the candidate.
  end
  
  def check_candidate
    tmp = bitify @candidate
    # if the trailing X chars of the string are all zeroes: WIN
    !!(tmp[0..(@level - 1)] =~ /^0+$/)
  end
  
  def run_proof
    make_target
    until check_candidate == true
      @nonce = increment @nonce
      make_target
    end
    
    @nonce
  end
  
  private
  
  # turns given string into a bit string after sha1 hashing it
  def bitify(target)
    list = target.split(//)
    bitv = ''
    list.each do |ch|
      st = ''
      # look for numbers and treat them as numbers
      # Meaning 0 not "0"
      if ch =~ /\d/
        st += pad(ch.to_i.to_s(2))
        
      else
        ch.each_byte do |by|
          st += pad by.to_s(2)
        end
      end
      
      bitv += st  # is this the place to worry about endianness? Or before, when padding?
    end
    
    bitv
  end

  # adds leading zeros to make 8 full bits
  def pad(byten)
    padding = '0' * (8 - byten.size)
    padding + byten
  end
end
