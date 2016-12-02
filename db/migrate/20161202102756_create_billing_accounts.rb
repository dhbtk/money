class CreateBillingAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :billing_accounts do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.boolean :enabled

      t.timestamps
    end
  end
end
