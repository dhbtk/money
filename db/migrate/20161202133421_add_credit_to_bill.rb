class AddCreditToBill < ActiveRecord::Migration[5.0]
  def change
    add_reference :bills, :credit, foreign_key: { to_table: :statements }
  end
end
