require 'digest'

class Payment < ActiveRecord::Base
  belongs_to :user
  has_attached_file :invoice, :default_url => "/images/invoices/missing.png"
  #validates :invoice, :attachment_presence => true Commented out because I can't figure out how to run tests with it in place!
  validates_attachment :invoice, content_type: { :content_type => ["image/jpg", "image/tif", "image/png", 'application/pdf'] }
  after_create :hash_transaction, :hash_image
  
  CURRENCIES = ['USD', 'EUR', 'BTC', 'INR', 'AUD', 'CAD', 'JPY']
  
  def testrun
    hash_image
  end
  
  private
  
  # creates hash of transaction that will be fed into block
  def hash_transaction
    dig = Digest::SHA256.new
    [user_id, merchant, currency, amount, created_at ].each do |thing|
      dig << thing.to_s
    end
    
    self.transaction_hash = dig.to_s
    save
  end
  
  def hash_image
    f = File.open(invoice.path, "rb")
    dig = Digest::SHA256.new
    f.each_byte do |by|  # doing it one byte at a time is horribly slow on large files.
  
      dig << by.to_s 
    end

    # Never modify an existing image, in case of tampering
    self.image_hash ||= dig.to_s
    save
  end
end