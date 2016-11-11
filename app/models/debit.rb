class Debit < ApplicationRecord
  belongs_to :recurring_debit, optional: true
  belongs_to :account
  belongs_to :tag, optional: true
  belongs_to :credit, optional: true

  has_one :transfer

  validates :date, :value, presence: true
end
