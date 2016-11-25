class Debit < ApplicationRecord
  self.sync_selectors = [
      {joins: :account, where: {accounts: {user_id: :x}}}
  ]
  belongs_to :recurring_debit, optional: true
  belongs_to :account
  belongs_to :tag, optional: true
  belongs_to :credit, optional: true

  has_one :transfer, dependent: :destroy

  validates :date, :value, presence: true

  after_initialize do
    self.date ||= DateTime.now.to_date
  end
end
