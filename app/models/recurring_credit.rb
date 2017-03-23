# == Schema Information
#
# Table name: recurring_credits
#
#  id          :integer          not null, primary key
#  name        :string
#  months      :integer
#  value       :decimal(8, 2)
#  account_id  :integer
#  expiration  :integer
#  interest    :decimal(8, 2)
#  fine        :decimal(8, 2)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  start_date  :datetime
#  category_id :integer
#
# Indexes
#
#  index_recurring_credits_on_account_id   (account_id)
#  index_recurring_credits_on_category_id  (category_id)
#

class RecurringCredit < ApplicationRecord
  audited
  belongs_to :account
  belongs_to :category, optional: true
  has_many :credits, -> { order(:date) }

  accepts_nested_attributes_for :credits

  validates :name, :value, :start_date, :months, presence: true
  validates :value, numericality: { greater_than: 0 }
  validates :months, numericality: { greater_than: 1 }

  def self.from_credit(credit)
    recurring_credit = RecurringCredit.new
    recurring_credit.name = credit.name
    recurring_credit.value = credit.value
    recurring_credit.account = credit.account
    recurring_credit.months = credit.months
    recurring_credit.start_date = credit.date
    recurring_credit.category = credit.category
    recurring_credit.save
    recurring_credit
  end

  def credits_value
    initial_value = value/months
    other_credits_value = initial_value - (initial_value % BigDecimal.new('0.01'))
    first_credit_value = other_credits_value + (value - other_credits_value*months)
    [first_credit_value] + (1..(months - 1)).map { |i| other_credits_value }
  end

  after_create do
    1.upto(months - 1) do |month|
      credit = Credit.from_recurring_credit(self, month)
      credit.save
    end
  end

  after_update do
    if months_was > months
      credits.order(:date)[months..-1].each(&:destroy)
    elsif months > months_was
      months_was.upto(months - 1) do |month|
        credit = Credit.from_recurring_credit(self, month)
        credit.save
      end
    end
    if start_date_was != start_date
      0.upto(months - 1) do |month|
        Credit.where(recurring_credit_id: id).order(:date).to_a[month].update(date: account.financed_credit_date(start_date + month.months, start_date))
      end
    end
    if value_was != value
      i = 0
      Credit.where(recurring_credit_id: id).order(:date).each do |credit|
        credit.update(value: credits_value[i])
        i += 1
      end
    end
    Credit.where(recurring_credit_id: id).update(name: name, account: account, category: category)
  end
end
