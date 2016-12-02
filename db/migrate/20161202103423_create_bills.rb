class CreateBills < ActiveRecord::Migration[5.0]
  def change
    create_table :bills do |t|
      t.references :billing_account, foreign_key: true
      t.string :name
      t.decimal :value
      t.timestamp :expiration

      t.timestamps
    end
  end
end
