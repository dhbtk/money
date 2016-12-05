class AddBarcodeToBill < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :barcode, :string
    add_column :bills, :attachment, :string
  end
end
