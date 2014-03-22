class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.string :merchant
      t.string :currency  #number_to_currency(price, :unit => "€")
      t.boolean :pre_approval, default: false
      t.string :transaction_hash
      t.string :image_hash
      t.decimal :amount, :precision => 12, :scale => 4
      t.string :comment

      t.timestamps
    end
  end
end
