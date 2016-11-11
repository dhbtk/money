class Credit < ApplicationRecord
  belongs_to :recurring_credit, optional: true
  belongs_to :account
  belongs_to :tag, optional: true
  has_many :debits

  validates :date, :value, presence: true
end
