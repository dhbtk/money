class Account < ApplicationRecord
  self.inheritance_column = 'record_type'
  has_many :credits, -> { order(:date) }
  has_many :recurring_credits, -> { order(:name) }
  has_many :debits, -> { order(:date) }
  has_many :recurring_debits, -> { order(:date) }
  has_many :transfers, through: :debits

  validates :name, presence: true, uniqueness: true

  enum type: { generic: 0, bank_account: 1, credit_card: 2 }

  # Simple account balance, not taking into account expired credits
  # nor this account's possible expiration/closing date.
  def balance(date = DateTime.now)
    debits.where('"date" <= ?', date).sum(:value) - credits.where('"date" <= ?', date).sum(:value)
  end
end
