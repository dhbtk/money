class Account < ApplicationRecord
  has_many :credits
  has_many :recurring_credits
  has_many :debits
  has_many :recurring_debits
  has_many :transfers, through: :debits
end
