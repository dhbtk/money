class CreateRecurringCredits < ActiveRecord::Migration[5.0]
  def change
    create_table :recurring_credits do |t|
      t.string :name
      t.integer :months
      t.integer :day
      t.decimal :value, precision: 8, scale: 2
      t.references :account, foreign_key: true
      t.integer :expiration
      t.decimal :interest, precision: 8, scale: 2
      t.decimal :fine, precision: 8, scale: 2

      t.timestamps
    end
  end
end
