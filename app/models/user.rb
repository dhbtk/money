class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :email, presence: true, uniqueness: true

  has_many :accounts, -> { order(:name) }
  has_many :billing_accounts, -> { order(:name) }
  has_many :bills, -> { except(:order).order(expiration: :desc) }, through: :billing_accounts
  has_many :tags, -> { order(:name) }
  has_many :credits, -> { except(:order).order(date: :desc, created_at: :desc) }, through: :accounts
  has_many :debits, -> { except(:order).order(date: :desc, created_at: :desc) }, through: :accounts
  has_many :statements, -> { except(:order).order(date: :desc, created_at: :desc) }, through: :accounts
  has_many :transfers, -> { except(:order).order(created_at: :desc) }, through: :credits

  def spending(days)
    totals = credits.unscope(:order).where.not(id: transfers.pluck(:credit_id)).where('date(date) >= ? and date(date) <= ?', days.days.ago.to_date, Date.today).order('date(date)').group('date(date)').sum('coalesce(value, 0)')
    dates = (0..(days - 1)).map { |i| i.days.ago.to_date }
    dates.each do |date|
      if totals[date].nil?
        totals[date] = 0
      end
    end

    totals = totals.to_a.sort { |a, b| a[0] <=> b[0] }.to_h
    [totals.keys, totals.values]
  end

  def spending_calendar(month = Date.today)
    rows = []
    row = []
    date = month.beginning_of_month
    while date <= month.end_of_month
      row << date
      if date.wday == 6
        rows << row
        row = []
      end
      date = date + 1.day
    end
    rows << row unless row.empty?

    # padding
    date = month.beginning_of_month - 1.day
    while rows[0].length != 7
      rows[0].unshift date
      date = date - 1.day
    end
    date = month.end_of_month + 1.day
    while rows[-1].length != 7
      rows[-1] << date
      date = date + 1.day
    end

    totals = credits.unscope(:order).where.not(id: transfers.pluck(:credit_id)).where('date(date) >= ? and date(date) <= ?', month.beginning_of_month, month.end_of_month).order('date(date)').group('date(date)').sum('coalesce(value, 0)')
    rows.map{|a| a.map{|day| [day, totals[day] || 0]}.to_h}
  end
end
