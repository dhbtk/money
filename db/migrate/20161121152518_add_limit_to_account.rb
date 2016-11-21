class AddLimitToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :limit, :decimal, precision: 8, scale: 2

    CreditCard.all.each{|c| c.update(limit: 0)}
  end
end
