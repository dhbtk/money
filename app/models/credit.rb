class Credit < ApplicationRecord
  belongs_to :recurring_credit, optional: true
  belongs_to :account
  belongs_to :tag, optional: true

  has_many :debits
  has_one :transfer, dependent: :destroy

  validates :date, :value, :account, presence: true
  validates :name, presence: true, if: 'months > 1'
  validates :date, uniqueness: { scope: :recurring_credit_id }, if: :recurring_credit

  def months
    @months || 1
  end

  def months=(val)
    @months = val.to_i
  end

  before_create do
    # Then we create a recurring credit
    if self.months > 1
      self.recurring_credit = RecurringCredit.from_credit(self) unless recurring_credit
    end
  end
end
