json.array!(@payments) do |payment|
  json.extract! payment, :id, :user_id, :merchant, :currency, :pre_approval, :transaction_hash, :image_hash
  json.url payment_url(payment, format: :json)
end
