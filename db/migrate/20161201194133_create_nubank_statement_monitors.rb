class CreateNubankStatementMonitors < ActiveRecord::Migration[5.0]
  def change
    create_table :nubank_statement_monitors do |t|
      t.references :account, foreign_key: true
      t.string :cpf
      t.string :password
      t.boolean :enabled
      t.json :data

      t.timestamps
    end
  end
end
