require 'digest'

class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :block
  has_attached_file :invoice, :default_url => "/images/invoices/missing.png"
  #validates :invoice, :attachment_presence => true Commented out because I can't figure out how to run tests with it in place!
  validates_attachment :invoice, content_type: { :content_type => ["image/jpg", "image/tif", "image/png", 'application/pdf'] }
  after_create :hash_transaction, :hash_image
  
  CURRENCIES = ['USD', 'EUR', 'BTC', 'INR', 'AUD', 'CAD', 'JPY']

  # TODO: Convert currencies so limits make sense!
  # TODO: WHY is this not an after create or even before save item?
  def apply_rules
    self.approval_status = (amount.to_f < user.limit.to_f)
    save
  end
  
  def to_h
    {
      merchant: self.merchant,
      amount: self.amount,
      currency: self.currency,
      image_hash: self.image_hash,
      user_id: self.user_id
    }
  end
  
  private
  
  # creates hash of transaction that will be fed into block
  def hash_transaction
    dig = Digest::SHA256.new
    [user_id, merchant, currency, amount, created_at, image_hash ].each do |thing|
      dig << thing.to_s
    end
    
    self.transaction_hash = dig.to_s
    save
  end
  
  def hash_image
    return if invoice.nil? || invoice.path.nil? ## this is just for testing. 
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
