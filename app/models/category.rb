# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  icon       :string
#
# Indexes
#
#  index_categories_on_user_id  (user_id)
#

class Category < ApplicationRecord
  audited
  belongs_to :user

  has_many :credits, dependent: :nullify
  has_many :debits, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :user_id }

  scope :with_recent_spending, -> do
    unscope(:order).select("id, name, icon, COALESCE((SELECT sum(value) FROM statements s JOIN accounts a ON s.account_id = a.id WHERE s.type = 'Credit' AND date(date) <= '#{Date.today}' AND date(date) >= '#{15.days.ago.to_date.to_s}' AND category_id = \"categories\".\"id\"), 0) as credit_total").order('credit_total DESC')
  end

  def color
  	  "##{(self.hash % 0xDDDDDD).to_s(16)}"
  end
end
