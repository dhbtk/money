class RemoveDayFromRecurringCredit < ActiveRecord::Migration[5.0]
  def change
    remove_column :recurring_credits, :day, :integer
    add_column :recurring_credits, :start_date, :timestamp
  end
end
