class RemoveTokenFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, [:uid, :provider]
    remove_column :users, :provider
    remove_column :users, :uid
    remove_column :users, :tokens
  end
end
