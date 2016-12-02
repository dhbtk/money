class UpdateRecurringCreditValue < ActiveRecord::Migration[5.0]
  def up
    RecurringCredit.all.each do |r|
      r.update(value: r.credits.sum(:value))
    end
  end
end
