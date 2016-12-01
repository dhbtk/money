class AddUserToTag < ActiveRecord::Migration[5.0]
  def change
    add_reference :tags, :user, foreign_key: true
    add_column :tags, :icon, :string
  end
end
