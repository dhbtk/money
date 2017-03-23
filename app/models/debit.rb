# == Schema Information
#
# Table name: statements
#
#  id                  :integer          not null, primary key
#  name                :string
#  type                :string
#  date                :datetime
#  value               :decimal(8, 2)
#  account_id          :integer
#  recurring_credit_id :integer
#  category_id         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_statements_on_account_id           (account_id)
#  index_statements_on_category_id          (category_id)
#  index_statements_on_recurring_credit_id  (recurring_credit_id)
#

class Debit < Statement
  audited
  has_one :transfer, dependent: :destroy

  validates :date, :value, presence: true

  after_initialize do
    self.date ||= Date.today
  end
end
