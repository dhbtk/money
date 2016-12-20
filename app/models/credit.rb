class Credit < Statement
  self.sync_selectors = [
      {joins: :account, where: {accounts: {user_id: :x}}}
  ]
  belongs_to :recurring_credit, optional: true

  has_one :transfer, dependent: :destroy
  has_one :bill, dependent: :nullify

  validates :date, :value, :account, presence: true
  validates :name, presence: true, if: 'months > 1'
  validates :date, uniqueness: {scope: :recurring_credit_id}, if: :recurring_credit

  def self.from_recurring_credit(recurring_credit, month)
    credit = Credit.new
    credit.name = recurring_credit.name
    credit.value = recurring_credit.credits_value[1]
    credit.account = recurring_credit.account
    puts "Data original: #{recurring_credit.start_date + month.months}"
    credit.date = credit.account.financed_credit_date(recurring_credit.start_date + month.months, recurring_credit.start_date)
    puts "Data alterada: #{credit.date}"
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
      self.value = self.recurring_credit.credits_value[0]
    end
  end
end
