class RenameTagsToCategories < ActiveRecord::Migration[5.0]
  def change
    rename_table :tags, :categories
  end
end
