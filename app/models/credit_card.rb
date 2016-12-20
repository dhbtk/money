class CreditCard < Account
  validates :expiration, :closing, :interest, :limit, presence: true

  def total_due
    balance = statements.where('date(date) < ?', next_closing_date).sum("CASE type WHEN 'Credit' THEN -value ELSE value END")
    balance > 0 ? 0 : balance.abs
  end

  def next_closing_date
    next_closing = Date.today.next_month.at_beginning_of_month + (closing - 1).days
    if next_closing - Date.today > Date.today.end_of_month.day # if we are 30+ days away...
      next_closing = Date.today.at_beginning_of_month + (closing - 1).days
    end
    next_closing
  end

  def available_limit
    limit + debits.sum(:value) - credits.sum(:value)
  end

  def financed_credit_date(date)
  	  date = date.to_date
  	  if date > next_closing_date
  	  	  Date.new(date.year, date.month, closing)
  	  else
  	  	  date
  	  end
  end
end
