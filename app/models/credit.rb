class Credit < ApplicationRecord
  self.sync_selectors = [
      {joins: :account, where: {accounts: {user_id: :x}}}
  ]
  belongs_to :recurring_credit, optional: true
  belongs_to :account
  belongs_to :tag, optional: true

  has_many :debits
  has_one :transfer, dependent: :destroy

  validates :date, :value, :account, presence: true
  validates :name, presence: true, if: 'months > 1'
  validates :date, uniqueness: {scope: :recurring_credit_id}, if: :recurring_credit

  def self.from_recurring_credit(recurring_credit, month)
    credit = Credit.new
    credit.name = recurring_credit.name
    credit.value = recurring_credit.value
    credit.account = recurring_credit.account
    credit.date = recurring_credit.start_date + month.months
    credit.recurring_credit = recurring_credit
    credit
  end

  def months
    @months || 1
  end

  def months=(val)
    @months = val.to_i
  end

  after_initialize do
    self.date ||= DateTime.now.to_date
  end

  before_create do
    # Then we create a recurring credit
    if self.months > 1
      self.recurring_credit = RecurringCredit.from_credit(self) unless recurring_credit
    end
  end
end
