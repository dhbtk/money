class Transfer < ApplicationRecord
  belongs_to :debit
  belongs_to :credit
end
