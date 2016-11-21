class CreditCard < Account
  validates :expiration, :closing, :interest, :limit, presence: true

  def total_due
    balance.abs
  end

  def available_limit
    limit + balance
  end
end
