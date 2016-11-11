class RecurringCredit < ApplicationRecord
  belongs_to :account

  has_many :credits

  validates :name, :value, :day, presence: true
end
