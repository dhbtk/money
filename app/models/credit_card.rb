class CreditCard < Account
  validates :expiration, :closing, :interest, :limit, presence: true

  def total_due
    balance = self.balance(Date.today.at_beginning_of_month + (closing - 2).days) # Until the day before the bill closes
    balance > 0 ? 0 : balance.abs
  end

  def available_limit
    limit + debits.sum(:value) - credits.sum(:value)
  end
end
