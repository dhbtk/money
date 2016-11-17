class CreditCard < Account
  validates :expiration, :closing, :interest, presence: true
end
