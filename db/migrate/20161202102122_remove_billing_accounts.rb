class RemoveBillingAccounts < ActiveRecord::Migration[5.0]
  def up
    Account.where(type: 'BillingAccount').destroy_all
  end
end
