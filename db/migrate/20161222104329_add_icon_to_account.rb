class AddIconToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :icon, :string
  end
end
