class Credit < ApplicationRecord
  belongs_to :recurring_credit, optional: true
  belongs_to :account
  belongs_to :tag, optional: true

  has_many :debits
  has_one :transfer, dependent: :destroy

  validates :date, :value, presence: true
end
