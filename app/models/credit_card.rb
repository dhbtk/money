class CreditCard < Account
  validates :expiration, :closing, :interest, :limit, presence: true

  def total_due
    balance.abs
  end

  def available_limit
    limit + debits.sum(:value) - credits.sum(:value)
  end
end
