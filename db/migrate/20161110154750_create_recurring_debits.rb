class CreateRecurringDebits < ActiveRecord::Migration[5.0]
  def change
    create_table :recurring_debits do |t|
      t.string :name
      t.integer :months
      t.integer :day
      t.decimal :value, precision: 8, scale: 2
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
