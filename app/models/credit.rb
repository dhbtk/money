class Credit < ApplicationRecord
  belongs_to :recurring_credit
  belongs_to :account
end
