class Account < ApplicationRecord
  self.inheritance_column = 'record_type'
  has_many :credits, -> { order(:date) }
  has_many :recurring_credits, -> { order(:name) }
  has_many :debits, -> { order(:date) }
  has_many :recurring_debits, -> { order(:date) }
  has_many :incoming_transfers, through: :debits, class_name: 'Transfer', source: :transfer
  has_many :outgoing_transfers, through: :credits, class_name: 'Transfer', source: :transfer

  validates :name, presence: true, uniqueness: true

  enum type: { generic: 0, bank_account: 1, credit_card: 2 }

  # Simple account balance, not taking into account expired credits
  # nor this account's possible expiration/closing date.
  def balance(date = DateTime.now)
    debits.where('"date" <= ?', date).sum(:value) - credits.where('"date" <= ?', date).sum(:value)
  end

  # Lists the statements in the given date range.
  def statements(from = 15.days.ago, to = 15.days.from_now)
    statements = debits.where('"date" <= ? AND "date" >= ?', to, from) + credits.where('"date" <= ? AND "date" >= ?', to, from)
    statements.sort{ |a, b| a.date <=> b.date }.group_by{ |x| [x.date.year, x.date.month, x.date.day] }
  end

  def self.statements_grid(from = 15.days.ago, to = 15.days.from_now)
    statements = all.map{|acc| [acc, acc.statements(from, to)]}.to_h
    statements.values.map{ |x| x.keys }.flatten(1).uniq.sort{ |x,y| DateTime.new(*x) <=> DateTime.new(*y) }
        .map{ |date| [date, statements.to_a.map{ |st| [st[0], st[1][date]] }] }.to_h
  end
end
