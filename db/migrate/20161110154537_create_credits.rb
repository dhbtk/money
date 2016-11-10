class CreateCredits < ActiveRecord::Migration[5.0]
  def change
    create_table :credits do |t|
      t.string :name
      t.datetime :date
      t.decimal :value, precision: 8, scale: 2
      t.references :recurring_credit, foreign_key: true
      t.references :account, foreign_key: true
      t.references :tag, foreign_key: true
      t.integer :expiration
      t.decimal :interest
      t.decimal :fine

      t.timestamps
    end
  end
end
