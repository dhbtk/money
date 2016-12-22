class RenameTagIdToCategoryId < ActiveRecord::Migration[5.0]
  def change
    rename_column :recurring_credits, :tag_id, :category_id
    rename_column :statements, :tag_id, :category_id
  end
end
