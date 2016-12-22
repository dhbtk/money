class Account < ApplicationRecord
  ICONS = Dir.glob(Rails.root.join(*%w[app assets images account_*.png])).map{ |x| File.basename x }
  audited
  belongs_to :user
  has_many :credits, -> { order(:date) }, dependent: :destroy
  has_many :recurring_credits, -> { order(:name) }, dependent: :destroy
  has_many :debits, -> { order(:date) }, dependent: :destroy
  has_many :statements
  has_many :incoming_transfers, through: :debits, class_name: 'Transfer', source: :transfer, dependent: :destroy
  has_many :outgoing_transfers, through: :credits, class_name: 'Transfer', source: :transfer, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :user, presence: true
  validates :icon, inclusion: { in: ICONS }, if: 'icon.present?'

  before_save do
    self.type = nil if type.blank? || type == 'Account'
  end

  # Simple account balance, not taking into account expired credits
  # nor this account's possible expiration/closing date.
  def balance(date = Date.today)
    debits.where('"date" <= ?', date).sum(:value) - credits.where('"date" <= ?', date).sum(:value)
  end

  def spending(days)
    dates = (0..(days - 1)).map{ |i| i.days.ago.to_date }
    totals = []
    dates.each do |date|
      totals << credits.where.not(id: outgoing_transfers.pluck(:credit_id)).where('date("date") = ?', date).sum(:value)
    end

    [dates.reverse, totals.reverse]
  end

  def financed_credit_date(date, today = Date.today)
  	  date
  end
end
