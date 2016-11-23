class RecurringDebit < ApplicationRecord
  self.sync_selectors = [
      {joins: :account, where: {accounts: {user_id: :x}}}
  ]
  belongs_to :account

  has_many :debits

  validates :name, :value, :day, presence: true
end
