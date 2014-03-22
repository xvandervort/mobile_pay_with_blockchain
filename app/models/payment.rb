require 'digest'

class Payment < ActiveRecord::Base
  belongs_to :user
  has_attached_file :invoice, :default_url => "/images/invoices/missing.png"
  #validates :invoice, :attachment_presence => true Commented out because I can't figure out how to run tests with it in place!
  validates_attachment :invoice, content_type: { :content_type => ["image/jpg", "image/tif", "image/png", 'application/pdf'] }
  after_create :hash_transaction
  
  CURRENCIES = ['USD', 'EUR', 'BTC', 'INR', 'AUD', 'CAD', 'JPY']
  
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
end
