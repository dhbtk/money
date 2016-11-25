class CreateRevisions < ActiveRecord::Migration[5.0]
  def change
    create_table :revisions do |t|
      t.references :model, polymorphic: true, index: true
      t.integer :revision_type
      t.json :data

      t.timestamps
    end
  end
end
