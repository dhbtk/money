# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  name       :string
#  expiration :integer
#  type       :string
#  closing    :integer
#  interest   :decimal(8, 4)
#  fine       :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  limit      :decimal(8, 2)
#  icon       :string
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#

class CreditCard < Account
  audited
  validates :expiration, :closing, :interest, :limit, presence: true
  validates :expiration, :closing, numericality: { greater_than: 0, less_than_or_equal_to: 31 }
  validates :interest, :limit, numericality: { greater_than_or_equal_to: 0 }

  def total_due
    balance = statements.where('date(date) < ?', next_closing_date).sum("CASE type WHEN 'Credit' THEN -value ELSE value END")
    balance > 0 ? 0 : balance.abs
  end

  def next_closing_date(today = Date.today)
    next_closing = today.next_month.at_beginning_of_month + (closing - 1).days
    if next_closing - today > today.end_of_month.day # if we are 30+ days away...
      next_closing = today.at_beginning_of_month + (closing - 1).days
    end
    next_closing
  end

  def available_limit
    limit + debits.sum(:value) - credits.sum(:value)
  end

  def financed_credit_date(date, today = Date.today)
    today = today.to_date
    if date > next_closing_date(today)
      Date.new(date.year, date.month, closing)
    else
      date.to_date
    end
  end
end
