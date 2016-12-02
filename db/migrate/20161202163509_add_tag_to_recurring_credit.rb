class AddTagToRecurringCredit < ActiveRecord::Migration[5.0]
  def change
    add_reference :recurring_credits, :tag, foreign_key: true
  end
end
