class RecurringCredit < ApplicationRecord
  belongs_to :account

  has_many :credits

  validates :name, :value, :start_date, :months, presence: true

  def self.from_credit(credit)
    recurring_credit = RecurringCredit.new
    recurring_credit.name = credit.name
    recurring_credit.value = credit.value
    recurring_credit.account = credit.account
    recurring_credit.months = credit.months
    recurring_credit.start_date = credit.date
    recurring_credit.save
    recurring_credit
  end

  after_create do
    1.upto(months - 1) do |month|
      credit = Credit.new
      credit.name = self.name
      credit.value = self.value
      credit.account = self.account
      credit.date = self.start_date + month.months
      credit.recurring_credit = self
      credit.save
    end
  end
end
