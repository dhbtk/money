class RecurringDebit < ApplicationRecord
  belongs_to :account
  has_many :debits
end
