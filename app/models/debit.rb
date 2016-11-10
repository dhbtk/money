class Debit < ApplicationRecord
  belongs_to :recurring_debit
  belongs_to :account
  belongs_to :tag
  belongs_to :credit
end
