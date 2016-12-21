class DropRevisions < ActiveRecord::Migration[5.0]
  def up
    drop_table :revisions
  end
end
