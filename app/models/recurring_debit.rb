class RecurringDebit < ApplicationRecord
  belongs_to :account

  has_many :debits

  validates :name, :value, :day, presence: true
end
