class ChangeAccountTypeToString < ActiveRecord::Migration[5.0]
  def up
    change_column :accounts, :type, :string
  end

  def down
    change_column :accounts, :type, :integer
  end
end
