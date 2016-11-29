class MoveCreditsAndDebitsToStatements < ActiveRecord::Migration[5.0]
  def up
    credits = <<-EOF
INSERT INTO statements (type, date, name, value, account_id, recurring_credit_id, tag_id, created_at, updated_at)
SELECT 'Credit' as type, date, name, value, account_id, recurring_credit_id, tag_id, created_at, updated_at FROM credits;
    EOF
    debits = <<-EOF
INSERT INTO statements (type, date, name, value, account_id, tag_id, created_at, updated_at)
SELECT 'Debit' as type, date, name, value, account_id, tag_id, created_at, updated_at FROM debits;
    EOF
    ApplicationRecord.connection.execute(credits)
    ApplicationRecord.connection.execute(debits)

    remove_foreign_key :transfers, :credits
    remove_foreign_key :transfers, :debits
    remove_foreign_key :debits, :credits
    drop_table :credits
    drop_table :debits
    Transfer.destroy_all
    add_foreign_key :transfers, :statements, column: :credit_id
    add_foreign_key :transfers, :statements, column: :debit_id
    transfers = <<-EOF
    insert into transfers (created_at, updated_at, credit_id, debit_id) select now() as created_at, now() as updated_at, c.id as credit_id, d.id as debit_id from statements c, statements d where c.type = 'Credit' and d.type = 'Debit' and c.account_id <> d.account_id and c.date = d.date and c.value = d.value;
    EOF
    ApplicationRecord.connection.execute(transfers)
  end
end
