class AddUserToTag < ActiveRecord::Migration[5.0]
  def change
    add_reference :categories, :user, foreign_key: true
    add_column :categories, :icon, :string
  end
end
