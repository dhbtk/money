class CreateStatements < ActiveRecord::Migration[5.0]
  def change
    create_table :statements do |t|
      t.string :name
      t.string :type
      t.datetime :date
      t.decimal :value, precision: 8, scale: 2
      t.references :account, foreign_key: true
      t.references :recurring_credit, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
