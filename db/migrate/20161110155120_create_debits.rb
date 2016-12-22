class CreateDebits < ActiveRecord::Migration[5.0]
  def change
    create_table :debits do |t|
      t.string :name
      t.datetime :date
      t.decimal :value, precision: 8, scale: 2
      t.references :recurring_debit, foreign_key: true
      t.references :account, foreign_key: true
      t.references :category, foreign_key: true
      t.references :credit, foreign_key: true

      t.timestamps
    end
  end
end
