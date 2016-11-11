class Account < ApplicationRecord
  self.inheritance_column = 'record_type'
  has_many :credits
  has_many :recurring_credits
  has_many :debits
  has_many :recurring_debits
  has_many :transfers, through: :debits

  validates :name, presence: true, uniqueness: true

  enum type: { generic: 0, bank_account: 1, credit_card: 2 }
end
