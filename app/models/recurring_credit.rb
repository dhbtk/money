class RecurringCredit < ApplicationRecord
  belongs_to :account
  has_many :credits
end
