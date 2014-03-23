class AddApprovalStatusToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :approval_status, :boolean, default: false
  end
end
