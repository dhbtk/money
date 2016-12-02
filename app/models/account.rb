class Account < ApplicationRecord
  self.sync_selectors = [
      {joins: nil, where: {user_id: :x}}
  ]
  belongs_to :user
  has_many :credits, -> { order(:date) }, dependent: :destroy
  has_many :recurring_credits, -> { order(:name) }, dependent: :destroy
  has_many :debits, -> { order(:date) }, dependent: :destroy
  has_many :statements
  has_many :recurring_debits, -> { order(:name) }, dependent: :destroy
  has_many :incoming_transfers, through: :debits, class_name: 'Transfer', source: :transfer, dependent: :destroy
  has_many :outgoing_transfers, through: :credits, class_name: 'Transfer', source: :transfer, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :user, presence: true

  before_save do
    self.type = nil if type.blank? || type == 'Account'
  end

  # Simple account balance, not taking into account expired credits
  # nor this account's possible expiration/closing date.
  def balance(date = DateTime.now.to_date)
    debits.where('"date" <= ?', date).sum(:value) - credits.where('"date" <= ?', date).sum(:value)
  end

  # Lists the statements in the given date range.
  def statements(from = 15.days.ago, to = 15.days.from_now)
    statements = debits.where('"date" <= ? AND "date" >= ?', to, from) + credits.where('"date" <= ? AND "date" >= ?', to, from)
    statements.sort { |b, a| r = a.date <=> b.date; r == 0 ? a.id <=> b.id : r }.group_by { |x| x.date.to_date }
  end

  def spending(days)
    dates = (0..(days - 1)).map{ |i| i.days.ago.to_date }
    totals = []
    dates.each do |date|
      totals << credits.where.not(id: outgoing_transfers.pluck(:credit_id)).where('date("date") = ?', date).sum(:value)
    end

    [dates.reverse, totals.reverse]
  end
end
