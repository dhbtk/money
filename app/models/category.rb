class Category < ApplicationRecord
  audited
  belongs_to :user

  has_many :credits, dependent: :nullify
  has_many :debits, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :user_id }

  scope :with_recent_spending, -> do
    unscope(:order).select("id, name, icon, COALESCE((SELECT sum(value) FROM statements s JOIN accounts a ON s.account_id = a.id WHERE s.type = 'Credit' AND date(date) <= '#{Date.today}' AND date(date) >= '#{15.days.ago.to_date.to_s}' AND category_id = \"categories\".\"id\"), 0) as credit_total").order('credit_total DESC')
  end
end
