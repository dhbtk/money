class CreateTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :transfers do |t|
      t.references :debit, foreign_key: true
      t.references :credit, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
