class RemoveBillingAccounts < ActiveRecord::Migration[5.0]
  def up
    Account.connection.execute("DELETE FROM accounts WHERE type = 'BillingAccount';")
  end
end
