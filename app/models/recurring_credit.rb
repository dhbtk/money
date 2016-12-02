class RecurringCredit < ApplicationRecord
  self.sync_selectors = [
      {joins: :account, where: {accounts: {user_id: :x}}}
  ]
  belongs_to :account
  belongs_to :tag, optional: true
  has_many :credits, -> { order(:date) }

  accepts_nested_attributes_for :credits

  validates :name, :value, :start_date, :months, presence: true

  def self.from_credit(credit)
    recurring_credit = RecurringCredit.new
    recurring_credit.name = credit.name
    recurring_credit.value = credit.value
    recurring_credit.account = credit.account
    recurring_credit.months = credit.months
    recurring_credit.start_date = credit.date
    recurring_credit.tag = credit.tag
    recurring_credit.save
    recurring_credit
  end

  def credits_value
    initial_value = value/months
    if initial_value.exponent < 3
      (1..months).map{|i| initial_value}
    else
      other_credits_value = initial_value - (initial_value % BigDecimal.new('0.01'))
      first_credit_value = other_credits_value + (value - other_credits_value*months)
      [first_credit_value] + (1..(months - 1)).map{|i| other_credits_value}
    end
  end

  after_create do
    1.upto(months - 1) do |month|
      credit = Credit.from_recurring_credit(self, month)
      credit.save
    end
  end

  after_update do
    puts "after_update"
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
        Credit.where(recurring_credit_id: id).to_a[month].update(date: start_date + month.months)
      end
    end
    if value_was != value
      i = 0
      Credit.where(recurring_credit_id: id).each do |credit|
        credit.update(value: credits_value[i])
        i += 1
      end
    end
    Credit.where(recurring_credit_id: id).update(name: name, account: account, tag: tag)
  end
end
