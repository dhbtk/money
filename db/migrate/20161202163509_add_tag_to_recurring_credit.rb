class AddTagToRecurringCredit < ActiveRecord::Migration[5.0]
  def change
    add_reference :recurring_credits, :category, foreign_key: true
  end
end
