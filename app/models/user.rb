class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  self.sync_selectors = [
      {joins: nil, where: {id: :x}}
  ]
  validates :email, presence: true, uniqueness: true

  has_many :accounts, -> { order(:name) }
  has_many :billing_accounts, -> { order(:name) }
  has_many :bills, through: :billing_accounts
  has_many :tags, -> { order(:name) }
  has_many :credits, -> { except(:order).order(date: :desc, created_at: :desc) }, through: :accounts
  has_many :debits, -> { except(:order).order(date: :desc, created_at: :desc) }, through: :accounts
  has_many :statements, -> { except(:order).order(date: :desc, created_at: :desc) }, through: :accounts
  has_many :transfers, -> { except(:order).order(created_at: :desc) }, through: :credits

  def spending(days)
  	  totals = credits.unscope(:order).where.not(id: transfers.pluck(:credit_id)).where('date(date) >= ? and date(date) <= ?', days.days.ago.to_date, Date.today).order('date(date)').group('date(date)').sum('coalesce(value, 0)')
    dates = (0..(days - 1)).map{ |i| i.days.ago.to_date }
    dates.each do |date|
    	if totals[date].nil?
    		totals[date] = 0
    	end
    end

	totals = totals.to_a.sort{|a,b| a[0] <=> b[0]}.to_h
	[totals.keys, totals.values]
  end
end
