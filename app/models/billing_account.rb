class BillingAccount < ApplicationRecord
  belongs_to :user
  has_many :bills, -> { order(expiration: :asc, created_at: :asc) }, dependent: :destroy

  validates :name, presence: true
end
