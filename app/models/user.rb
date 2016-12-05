class User < ApplicationRecord
  self.sync_selectors = [
      {joins: nil, where: {id: :x}}
  ]
  validates :email, presence: true, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :accounts, -> { order(:name) }
  has_many :billing_accounts, -> { order(:name) }
  has_many :bills, through: :billing_accounts
  has_many :tags, -> { order(:name) }
  has_many :credits, -> { except(:order).order(date: :desc, created_at: :desc) }, through: :accounts
  has_many :debits, -> { except(:order).order(date: :desc, created_at: :desc) }, through: :accounts
  has_many :statements, -> { except(:order).order(date: :desc, created_at: :desc) }, through: :accounts
  has_many :transfers, -> { except(:order).order(created_at: :desc) }, through: :credits

  def spending(days)
    dates = (0..(days - 1)).map{ |i| i.days.ago.to_date }
    totals = []
    dates.each do |date|
      totals << credits.where.not(id: transfers.pluck(:credit_id)).where('date("date") = ?', date).sum(:value)
    end

    [dates.reverse, totals.reverse]
  end
end
