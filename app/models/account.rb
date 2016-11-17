class Account < ApplicationRecord
  belongs_to :user
  has_many :credits, -> { order(:date) }
  has_many :recurring_credits, -> { order(:name) }
  has_many :debits, -> { order(:date) }
  has_many :recurring_debits, -> { order(:date) }
  has_many :incoming_transfers, through: :debits, class_name: 'Transfer', source: :transfer
  has_many :outgoing_transfers, through: :credits, class_name: 'Transfer', source: :transfer

  validates :name, presence: true, uniqueness: true
  validates :user, presence: true

  # Simple account balance, not taking into account expired credits
  # nor this account's possible expiration/closing date.
  def balance(date = DateTime.now)
    debits.where('"date" <= ?', date).sum(:value) - credits.where('"date" <= ?', date).sum(:value)
  end

  # Lists the statements in the given date range.
  def statements(from = 15.days.ago, to = 15.days.from_now)
    statements = debits.where('"date" <= ? AND "date" >= ?', to, from) + credits.where('"date" <= ? AND "date" >= ?', to, from)
    statements.sort{ |b, a| r = a.date <=> b.date; r == 0 ? a.id <=> b.id : r }.group_by{ |x| x.date.to_date }
  end
end
